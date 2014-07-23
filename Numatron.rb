#!/usr/bin/env ruby
# Made by vifino
# Copyright 2014
APP_ROOT = File.dirname(__FILE__)
require 'yaml'
def runDir(dir)
	Dir["#{dir}/**/*.rb"].each{|s| load s }
end
def loadSettings(file = "settings.rb")
	#file = APP_ROOT+file
	load file # IK, dangerous.
	@server = @settings["server"]
	@port = @settings["port"]
	@nick = @settings["nickname"]
	@username = @settings["username"]
	@realname = @settings["realname"]
	@channels = @settings["channels"]
	@admins = @settings["admins"]
	@prefix = @settings["prefix"] or "#"
	begin
		@password = @settings["password"]
	rescue => detail
		@password = nil
	end
end
$commands = Hash.new()
loadSettings
runDir "core"
# spacer! \o/
def commandRunner(cmd,nick,chan)
	retFinal=""
	retLast=""
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	retLast=rnd
	cmdarray = cmd.scan(/(?:[^|\\]|\\.)+/) or [cmd]
	#func, args = cmd.lstrip().split(' ', 2)
	cmdarray.each {|cmd|
		cmd = cmd.gsub("\\|","|")
		func, args = cmd.lstrip().split(' ', 2)
		func=func.downcase()
		if $commands[func] then
			if retLast==rnd then
				retLast = ""
				if $commands[func].is_a?(Method) then
					retLast = $commands[func].call(args, nick, chan, args, nil)
					retLast = retLast or ""
				else
					retLast = self.send($commands[func], args, nick, chan, args, nil)
					retLast = retLast or ""
				end
			else
				if $commands[func].is_a?(Method) then
					retLast = $commands[func].call(args, (args or "")+retLast, chan, args, retLast)
					retLast = retLast or ""
				else
					retLast = self.send($commands[func], (args or "")+retLast, nick, chan, args, retLast)
					retLast = retLast or ""
				end
				#retLast=self.send(@commands[func],(args or "")+retLast,nick,chan) or ""
			end
		else
			retLast = "No such function: '#{func}'"
			break
		end
	}
	#call func
	#if @commands[func] then
	#	retLast=self.send(@commands[func],args,nick,chan)
		return retLast if not retLast==rnd
	#end
end
def commandParser(cmd,nick,chan)
	job_parser = fork do
		begin
			ret=commandRunner(cmd, nick, chan)
			if ret then
				if ret.length > 200 then
					@bot.msg(chan,"> Output: "+putHB(ret.to_s))
				else
					@bot.msg(chan,"> "+ret.to_s)
				end
			end
		rescue => detail
			@bot.msg(chan,detail.message())
		end
		exit
	end
	Process.detach(job_parser)
end
def logic(raw)
	type,nick,to,msg = @bot.msgtype(raw)
	if type == "msg" then
		if to==@bot.nick then to=nick end
		puts "#{nick} -> #{to}: "+msg
		if msg.match(/^\#{@prefix}(.*)/) then
			begin
				commandParser "#{$~[1]}",nick,to
			rescue Exception => detail
				@bot.msg(to,detail.message())
			end
		end
	else
		puts raw
	end
end
def run
	until @bot.socket.eof? do
		raw = @bot.receive
		if raw then
			@fiforaw.puts raw
			logic raw
			@fiforaw.flush
		end
	end
end
def setup
	#@bot.join("#ocbots")
	#@bot.join("#tkbots")
	@fiforawRead = Fifo.new
	@fiforawRead.openRead("pipes/raw")
	@fiforaw = Fifo.new
	@fiforaw.openWrite("pipes/raw")
	@fiforaw.flush
	#@fiforaw = open("pipes/raw","w+")
	@bot = IRC.new(@server,@port,@nick,@username,@realname,@password)
	trap("INT"){ @bot.quit }
	runDir "modules"
	@channels.each { |chan| @bot.join(chan)}
end
setup
run

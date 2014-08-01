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
	@cmdnotfound = @settings["notFoundmsg"]
	@jruby = @settings["jruby"]
	begin
		@blacklistChannels = @settings["blacklistChannels"] or []
	rescue => detail
		@blacklistChannels = []
	end
	begin
		@password = @settings["password"] or nil
	rescue => detail
		@password = nil
	end
	begin
		@ssl = @settings["ssl"]
	rescue => e
		@ssl=false
	end
end
def init_fifos
	@fifopassive = open("pipes/passive","w+")
	@fifopassive.flush
	@fifoauth = open("pipes/auth","w+")
	@fifoauth.flush
end
def sendfifos(raw)
	@fifopassive.puts raw
	@fifopassive.flush
	@fifoauth.puts raw
	@fifoauth.flush
end
$commands = Hash.new()
@rawhooks = []
loadSettings
runDir "core"
def runRaw(raw)
	@rawhooks.each {|item|
	if item.is_a?(Method) then
		$commands[func].call(raw)
	else
		self.send(item,raw)
	end
	}
end
# spacer! \o/
def subcommandParser(args="",nick,chan)
	args.gsub(/\${(.*)}/) {|cmdN|
		if not cmdN.empty? then
			commandRunner((cmdN.strip.gsub("${","").gsub("}","") or cmdN), nick, chan)
		end
	}
end
def commandRunner(cmd,nick,chan)
	cmd=cmd.strip
	retFinal=""
	retLast=""
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	retLast=rnd
	cmdarray = cmd.scan(/(?:[^|\\]|\\.)+/) or [cmd]
	#func, args = cmd.lstrip().split(' ', 2)
	cmdarray.each {|cmd|
		cmd=cmd.lstrip
		if cmd then
			cmd = cmd.gsub("\\|","|")
			func, args = cmd.split(' ', 2)
			args = subcommandParser((args or ""),nick,chan)
			func=func.downcase()
			if $commands[func] then
				if retLast==rnd then
					retLast = ""
					if $commands[func].is_a?(Method) then
						retLast = $commands[func].call(args, nick, chan, args, "")
						retLast = retLast.to_s.rstrip or ""
					elsif $commands[func].class == Proc then
						retLast = $commands[func].call(args, nick, chan, args, "")
						retLast = retLast.to_s.rstrip or ""
					elsif $commands[func].class == String then
								retLast = $command[func].to_s.rstrip or ""
					else
						retLast = self.send($commands[func], args, nick, chan, args, "")
						retLast = retLast.to_s.rstrip or ""
					end
				else
					if $commands[func].is_a?(Method) then
						retLast = $commands[func].call(args, (args or "")+retLast, chan, args, retLast)
						retLast = retLast.to_s.rstrip or ""
					elsif $commands[func].class == Proc then
						retLast = $commands[func].call(args, (args or "")+retLast, chan, args, retLast)
						retLast = retLast.to_s.rstrip or ""
					elsif $commands[func].class == String then
							retLast = $command[func].to_s.rstrip or ""
					else
						retLast = self.send($commands[func], (args or "")+retLast, nick, chan, args, retLast)
						retLast = retLast.to_s.rstrip or ""
					end
				#retLast=self.send(@commands[func],(args or "")+retLast,nick,chan) or ""
				end
			else
				if @cmdnotfound then
					retLast = "No such function: '#{func}'"
				end
				break
			end
		end
	}
	#call func
	#if @commands[func] then
	#	retLast=self.send(@commands[func],args,nick,chan)
	return retLast.rstrip if not (retLast==rnd or (retLast.to_s or "").empty?)
	#end
end
def commandParser(cmd,nick,chan)
	#job_parser = fork do
	Thread.new do
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
		#exit
	end
	#Process.detach(job_parser)
end
def logic(raw)
	type,nick,to,msg = @bot.msgtype(raw)
	#sendfifos raw
	begin
		runRaw raw
	rescue => e
		puts e
		# Todo: do something more useful with output
	end
	if type == "msg" then
		if to==@bot.nick then to=nick end
		puts "#{nick} -> #{to}: "+msg
		prefix = @prefix or "\?"
		if msg.match(/^#{prefix}(.*)/) then
			begin
				if not @blacklistChannels.include? to.strip.downcase then
					commandParser "#{$~[1]}",nick,to
				end
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
			logic raw
		end
	end
end
def setup
	#init_fifos
	#@fiforaw = open("pipes/raw","w+")
	@authread,@authwrite = IO.pipe
	@bot = IRC.new(@server,@port,@ssl,@nick,@username,@realname,@password)
	trap("INT"){ @bot.quit; abort }
	runDir "modules"
	#sleep(2)
	@channels.each { |chan|
		@bot.join(chan)
		who chan
		sleep(0.2)
		}
end
until false do
	begin
		setup
		run
	rescue => e
	sleep(60)
	end
end

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
def init_fifos # not used anymore...
	@fifopassive = open("pipes/passive","w+")
	@fifopassive.flush
	@fifoauth = open("pipes/auth","w+")
	@fifoauth.flush
end
def sendfifos(raw) # This is not used too.
	@fifopassive.puts raw
	@fifopassive.flush
	@fifoauth.puts raw
	@fifoauth.flush
end
@rawhooks = []
loadSettings
$commands ||= Hash.new()
runDir "core"
def runRaw(raw)
	@rawhooks.each {|item|
	if item.is_a?(Method) then
		item.call(raw)
	else
		self.send(item,raw)
	end
	}
end
# spacer! \o/
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

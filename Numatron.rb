#!/usr/bin/env ruby
# Made by vifino
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
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
		@blacklistAcc = @settings["blacklistAcc"] or []
	rescue => detail
		@blacklistAcc = []
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
	begin
		@afternick = @settings["afternick"] || @settings["nickname"]
	rescue => e
		@afternick = @settings["nickname"]
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
load "core/parser.rb" # Makes sure that the parser loads first.
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
def cmdrun(cmd,nick,to)
	begin
		if not @blacklistChannels.include? to.strip.downcase then
			commandParser cmd,nick,to
		end
	rescue Exception => detail
		@bot.msg(to,detail.message())
	end
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
		if msg.match(/^#{Regexp.escape(prefix)}(.*)/) then
			cmdrun "#{$~[1]}",nick,to if (!isBlacklisted? nick)
		elsif msg.match(/^#{Regexp.escape(@bot.nick)}.(.*)/) then
			cmdrun "#{$~[1]}",nick,to if (!isBlacklisted? nick)
		end
	elsif type=="invite" then
		#if not @blacklistChannels.include? msg.strip.downcase then
			@bot.join msg
			who msg
			@bot.msg msg,"Hello! :3"
		#end
	#else
		#puts raw
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
	trap("INT"){ @bot.quit; abort }
	trap("TERM"){ @bot.quit; abort }
	@bot = IRC.new(@server,@port,@ssl,@nick,@username,@realname,@password)
	if @afternick then
		@bot.chnick @afternick
	end
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
		puts e.to_s
	sleep(60)
	end
end

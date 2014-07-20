#!/usr/bin/env ruby
# Made by vifino
# Copyright 2014
APP_ROOT = File.dirname(__FILE__)
require 'socket'
require 'yaml'
class IRC
	attr_reader :nick
	attr_reader :username
	attr_reader :realname
	attr_reader :socket
	def initialize(server, port, nick,user=nick,realname = nick,pass = nil)
		@nick = nick
		@username = user
		@realname = realname
		@socket = TCPSocket.open(server, port)
		send "NICK #{@nick}"
		send "USER #{@nick} ~ ~ :#{@realname}"
		if pass then
			identify pass
		end
		initialised = false
		until initialised
			msg = @socket.gets
			if msg then
				if msg.match(/^PING :(.*)$/)
					@socket.puts "PONG #{$~[1]}"
				end
				if msg.include? ":End of /MOTD command."
					puts "Initialized"
					initialised=true
					break
				end
			end
		end
	end
	def send(msg)
		@socket.puts msg+ "\r\n"
	end
	def msg(chan,msg)
		send "PRIVMSG #{chan} :"+msg
	end
	def join(chan)
			send "JOIN #{chan}"
	end
	def receive
		msg = @socket.gets
		if msg.match(/^PING :(.*)$/)
			send "PONG #{$~[1]}"
		end
		return msg.delete("\r\n")
	end
	def quit
		send 'QUIT'
	end
	def identify(pass)
		send "PASS :#{pass}"
	end
	def msgtype(msg)
		if match = msg.match(/^:(.*)!(.*)@(.*) PRIVMSG (.*) :(.*)/) then
			#return "msg","#{$~[1]}","#{$~[4]}","#{$~[5]}"
			return "msg", match[1], match[4], match[5].gsub("\:","\:")
		else
			return "other",msg
		end
	end
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
	begin
		@password = @settings["password"]
	rescue Exception => detail
		@password = nil
	end
end
@commands = Hash.new()
def isPrivileged(nick)
	#if nick == "vifino" then
	#	return true
	#end
	return true if @admins.include? nick
	return false
	#return false
end
# Commands here.
def say(args,nick,chan)
	@bot.msg(chan,"> "+args)
end
@commands["say"] = "say"
def rb(args,nick,chan)
	if (isPrivileged nick) and args != nil then
		job_rb = fork do
			begin
				returnval = eval args
				if returnval!=nil then
					@bot.msg(chan,"=> "+ returnval.inspect)
				end
			rescue Exception => detail
				@bot.msg(chan,detail.message())
			end
		end
		Process.detach(job_rb)
	end
end
@commands["rb"] = "rb"
def raw(args,nick,chan)
	return true if nick == "vifino"
end
@commands["raw"] = "raw"
# spacer! \o/
def commandParser(cmd,nick,chan)
	func, args = cmd.split(' ', 2)
	if @commands[func] then
		job_parser = fork do
			begin
				_,ret=self.send(@commands[func],args,nick,chan)
				if ret then
					@bot.msg(chan,"> "+ret.to_s)
				end
			rescue Exception => detail
				@bot.msg(chan,detail.message())
			end
		end
		Process.detach(job_parser)
	end
end
def logic(raw)
	type,nick,to,msg = @bot.msgtype(raw)
	if type == "msg" then
		puts "#{nick} -> #{to}: "+msg
		if msg.match(/\?(.*)/) then
			begin
				commandParser "#{$~[1]}",nick,to
			rescue Exception => detail
				@bot.msg(to,detail.message())
			end
		end
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
	#@bot.join("#ocbots")
	#@bot.join("#tkbots")
	loadSettings
	@bot = IRC.new(@server,@port,@nick,@username,@realname,@password)
	trap("INT"){ @bot.quit }
	@channels.each { |chan| @bot.join(chan)}
end
setup
run

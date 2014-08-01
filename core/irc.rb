# IRC Connector and basic framework
# Made by vifino
require 'socket'
require "openssl"
class IRC
	attr_reader :nick
	attr_reader :username
	attr_reader :realname
	attr_reader :socket
	attr_reader :lastline
	def initialize(server, port, ssl, nick, user, realname, pass=nil)
		@nick = nick
		@username = user
		@realname = realname
		if ssl then
			sock = TCPSocket.new(server,port)
			sleep 2
			ssl_context = OpenSSL::SSL::SSLContext.new
			ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
			irc = OpenSSL::SSL::SSLSocket.new(sock, ssl_context)
			irc.sync = true
			irc.connect
			@socket = irc
		else
			@socket = TCPSocket.open(server, port)
		end
		@lastline = nil
		@hookRaw = Array.new
		send "NICK #{@nick}"
		send "USER #{@nick} ~ ~ :#{@realname}"
		if pass then
			identify pass
		end
		initialised = false
		until initialised
			msg = @socket.gets
			if msg then
				puts msg
				if msg.match(/^PING :(.*)$/)
					@socket.puts "PONG #{$~[1]}"
				end
				if msg.include? ":End of /MOTD command."
					break
					initialised=true
				end
			end
		end
		puts "Initialized"
	end
	def send(msg)
		if msg then
			@socket.puts(msg+ "\r\n")
		end
	end
	def msg(chan,msg)
		msg.each_line {|m|
			length = 512-("PRIVMSG #{chan} :").length
			send "PRIVMSG #{chan} :"+m
		}
	end
	def join(chan)
		send "JOIN #{chan}"
	end
	def part(chan,message=nil)
		if message==nil then
			send "PART #{chan}"
		else
			send "PART #{chan} :#{message}"
		end
	end
	def notice(chan,msg)
		send "NOTICE #{chan} :#{msg}"
	end
	def mode(chan,nick,mode)
		send "MODE #{chan} #{mode} #{nick}"
	end
	def receive
		msg = @socket.gets
		if msg.match(/^PING :(.*)$/)
			send "PONG #{$~[1]}"
		end
		@lastline = msg.delete("\r\n")
		return msg.delete("\r\n")
	end
	def quit(msg=nil)
		if msg==nil then
			send 'QUIT'
		else
			send "QUIT :#{msg}"
		end
	end
	def identify(pass)
		send "PASS :#{pass}"
	end
	def ctcp(chan,msg)
		self.msg(chan,"\x01#{msg}\x01")
	end
	def action(chan,msg)
		self.msg(chan,"\x01ACTION #{msg}\x01")
	end
	def msgtype(msg)
		if match = msg.match(/^:(.*)!(.*)@(.*) PRIVMSG (.*?) :\x01ACTION (.*)\x01/) then
			return "action", match[1], match[4], match[5],match[2],match[3]
		elsif match = msg.match(/^:(.*)!(.*)@(.*) PRIVMSG (.*?) :(.*)/) then
			return "msg", match[1], match[4], match[5],match[2],match[3]
		elsif match = msg.match(/^:(.*)!(.*)@(.*) NOTICE (.*?) :(.*)/) then
			return "notice", match[1], match[4], match[5],match[2],match[3]
		elsif match = msg.match(/^:(.*)!(.*)@(.*) JOIN (.*?)/) then
			return "join", match[1], match[4],nil, match[2],match[3]
		elsif match = msg.match(/^:(.*)!(.*)@(.*) PART (.*?) :(.*)/) then
			return "part", match[1], match[4], match[5],match[2],match[3]
		elsif match = msg.match(/^:(.*)!(.*)@(.*) MODE (.*?) (.*?) (.*)/) then
				return "mode", match[1], match[4], match[6], match[5],match[2],match[3]
		elsif match = msg.match(/^:(.*)!(.*)@(.*) NICK :(.*)/) then
			return "nick", match[1], match[4],nil, match[2],match[3]
		else
			return "other",msg
		end
	end
end

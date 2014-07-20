# IRC Connector and basic framework
# Made by vifino
require 'socket'
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
		return msg.delete("\r\n")
	end
	def quit
		send 'QUIT'
	end
	def identify(pass)
		send "PASS :#{pass}"
	end
	def msgtype(msg)
		if match = msg.match(/^:(.*)!(.*)@(.*) PRIVMSG (.*?) :(.*)/) then
			#return "msg","#{$~[1]}","#{$~[4]}","#{$~[5]}"
			return "msg", match[1], match[4], match[5].gsub("\:","\:")
		else
			return "other",msg
		end
	end
end

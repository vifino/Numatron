# CTCP replies and... things.
# Made by vifino
require 'timeout'
def ctcpping(usr)
	@bot.ctcp(usr,"PING "+Time.now.to_i.to_s+" 12345")
	isResponse=false
	t1=Time.now
	ret=""
	begin
		Timeout::timeout(5) do
			while true do
				data= @bot.msgtype(@bot.lastline)
				type = data[0]
				nick = data[1]
				chan = data[2]
				msg = data[3]
				username = data[4]
				hostname = data[5]
				if type=="notice" and nick=usr then#msg.match(/^\x01PING(.*)$\x01/)
					#ret=msg
					if tmestmp=msg
					break
				end
			end
			return "Returned: #{ret.strip}. #{(Time.now-t1).to_s} Seconds passed." # ....?
		end
	rescue => e
		return "Timeout."
	end
end
def ping(args="",nick="",chan="",rawargs="",pipeargs="")
	if not args.empty? then
		ctcpping(args.split(" ").first)
	else
		ctcpping(nick)
	end
end
addCommand("ping",:ping,"CTCP PINGs the user.")
addCommand("p",:ping,"CTCP PINGs the user.")

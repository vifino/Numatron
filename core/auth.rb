# Basic Authing of users
# Made by vifino
def isPrivileged? nick
	return true if @admins.include? nick.downcase
	return false
end
def getNSAcc(nick) # do not use
	runcount = 0
	account = nil
	if nick and @bot.lastline then
		gotInfo = false
		@bot.msg("NickServ","info "+nick)
		until gotInfo do
			runcount += 1
			if runcount > 100000 then break; return nil; end
			type,from,to,msg = @bot.msgtype(@bot.receive())
			#type,from,to,msg = @bot.msgtype @bot.lastline
			if type=="notice" and from == "NickServ" then
				ret = msg.match(/\(account (.*?)\)/)
				if ret = msg.match(/\(account (.*?)\)/) then
					return ret
					break
				end
			end
		end
	end
	return "fak dis"
end

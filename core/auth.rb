# Basic Authing of users
# Made by vifino
def isPrivileged? nick
	return true if @admins.include? nick.downcase
	return false
end
def getNSAcc(nick) # do not use
	if not @fifoNS then
		@fifoNS = Fifo.new
		@fifoNS.openMode("pipes/raw","r")
		#@fifoNS.flush
	end
	runcount = 0
	account = nil
	if nick then
		gotInfo = false
		@bot.msg("NickServ","info "+nick)
		until gotInfo do
			#sleep 0.5
			runcount += 1
			if runcount > 20 then break; return "Not found anything."; end
			type,from,to,msg = @bot.msgtype(@fifoNS.gets)
			#type,from,to,msg = @bot.msgtype @bot.lastline
			if type=="notice" and from == "NickServ" then
				ret = msg.match(/\(account (.*?)\)/)
				if ret = msg.match(/\(account (.*?)\)/) then
					return ret #((ret.gsub(/\(account /," ") or ret).gsub(/\)/) or ret)
					break
				end
			end
		end
	end
	return "fak dis"
end

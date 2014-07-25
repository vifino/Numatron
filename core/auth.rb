# Basic Authing of users
# Made by vifino
def isPrivileged? nick
	return true if @admins.include? nick.downcase
	return false
end
def getNSAcc(nick) # do not use, doesnt work
	@authread,@authwrite = IO.pipe
	runcount = 0
	account = nil
	if nick then
		gotInfo = false
		@bot.msg("NickServ","info "+nick)
		until gotInfo do
			sleep 1
			#runcount += 1
			#if runcount > 50 then; return "Not found anything in time."; end
			#if @passivedata[nick]["acc"] then
				return @authread.gets
			#end
		end
	end
end

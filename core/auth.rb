# Basic Authing of users
# Made by vifino
def isPrivileged? nick
	return true if @admins.include? getNSAcc(nick)
	return false
end
def who(chan) # Not so passive :3
	@bot.send "WHO #{chan} c%cuihsnfar"
end
def whois(user)
	@bot.send "whois #{user}"
end
def getNSAcc(user)
	who user
	sleep (0.5)
	if not user.include? "#" then
		for i in 0..20
			if @passivedata["users"][user] then
				if acc=@passivedata["users"][user]["acc"] then
					return acc
				end
				sleep(0.2)
			end
		end
		return nil
	else
		return "Channel not a user!"
	end
end

# Advanced commands
# Made by vifino
def disguise(args="",nick="",chan="",rawargs="",pipeargs="")
	if isPrivileged? nick then
		user, cmd = args.split(' ', 2)
		if user and cmd then
			puts user
			nickn= argParser(user,nick,chan)
			return commandRunner(cmd,nickn,chan)
		else
			return "Missing input."
		end
	else
		"You aren't allowed to disguise as others!"
	end
end
addCommand("disguise",:disguise,"Disguise as other users, Admin only!",true)
addCommand("cloak",:disguise,"Disguise as other users, Admin only!",true)

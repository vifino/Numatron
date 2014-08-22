# Advanced commands
# Made by vifino
def disguise(args="",nick="",chan="",rawargs="",pipeargs="")
	if isPrivileged? nick then
		user, cmd = args.split(' ', 2)
		return commandRunner(cmd,user,chan)
	else
		"You aren't allowed to disguise as others!"
	end
end
addCommand("disguise",:disguise,"Disguise as other users, Admin only!",true)
addCommand("cloak",:disguise,"Disguise as other users, Admin only!",true)

# Execute shell commands
# Made by vifino
def sh(args="")
	if not args.to_s.empty? then
		return `#{args}`
	end
end
def shcmd(args="",nick="",chan="",rawargs="",pipeargs="")
	if isPrivileged? nick then
		return sh(args.to_s)
	else
		return "Errrr.... No?"
	end
end
$commands["sh"] = :shcmd

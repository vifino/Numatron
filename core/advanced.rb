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
def ifcmd(args="",nick="",chan="",rawargs="",pipeargs="")
	# if 1==1 then break world
	argst=args.to_s.split("then",2)
	# Logic to parse the expression
	logic = argst[0].strip
	res=nil
	if logic.include? "==" then # Comparison
		puts "=="
		p1,p2=logic.split("==")
		res=(p1==p2)
	elsif logic.include? "!=" # Inverted comparison
		puts "!="
		p1,p2=logic.split("!=")
		res=(p1!=p2)
	else
		res=!logic.empty?
	end
	if res==true then # aka the upper logic fits
		return commandRunner(argst[1],nick,chan)
	else
		# tbd
	end
end
addCommand("if",:ifcmd,"Evaluates an if statement.")

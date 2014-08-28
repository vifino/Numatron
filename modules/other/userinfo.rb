# Get data of users
# Made by vifino
def hostnamecmd(args="",nick="",chan="",rawargs="",pipeargs="")
	user=nick
	if not args.empty? then
		user=args.split(" ").first
	end
	if @passivedata["users"][user] then
		return (@passivedata["users"][user]["host"] or "No such record.")
	else
		return "No data on User #{user}."
	end
end
addCommand("host",:hostnamecmd,"Return the hostname of a user.")
def realnamecmd(args="",nick="",chan="",rawargs="",pipeargs="")
	user=nick
	if not args.empty? then
		user=args.split(" ").first
	end
	if @passivedata["users"][user] then
		return (@passivedata["users"][user]["real"] or "No such record.")
	else
		return "No data on User #{user}."
	end
end
addCommand("real",:realnamecmd,"Return the realname of a user.")
def usernamecmd(args="",nick="",chan="",rawargs="",pipeargs="")
	user=nick
	if not args.empty? then
		user=args.split(" ").first
	end
	if @passivedata["users"][user] then
		return (@passivedata["users"][user]["user"] or "No such record.")
	else
		return "No data on User #{user}."
	end
end
addCommand("user",:usernamecmd,"Return the username of a user.")
def accnamecmd(args="",nick="",chan="",rawargs="",pipeargs="")
	user=nick
	if not args.empty? then
		user=args.split(" ").first
	end
	if @passivedata["users"][user] then
		return (@passivedata["users"][user]["acc"] or "No such record.")
	else
		return "No data on User #{user}."
	end
end
addCommand("acc",:accnamecmd,"Return the Accountname of a user.")
def servernamecmd(args="",nick="",chan="",rawargs="",pipeargs="")
	user=nick
	if not args.empty? then
		user=args.split(" ").first
	end
	if @passivedata["users"][user] then
		return (@passivedata["users"][user]["server"] or "No such record.")
	else
		return "No data on User #{user}."
	end
end
addCommand("server",:servernamecmd,"Return the Servername of a user.")

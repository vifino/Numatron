# Get data of users
# Made by vifino
def hostnamecmd(args="",nick="",chan="",rawargs="",pipeargs=""))
	user=nick
	if not args.empty? then
		nick=args.split(" ").first
	end
	if m=@passivedata["users"][user] then
		return m["host"] or "No such record."
	else
		return "No data on User #{user}."
	end
end
addCommand("host",:hostnamecmd,"Return the hostname of a user.")
def realnamecmd(args="",nick="",chan="",rawargs="",pipeargs=""))
	user=nick
	if not args.empty? then
		nick=args.split(" ").first
	end
	if m=@passivedata["users"][user] then
		return m["real"] or "No such record."
	else
		return "No data on User #{user}."
	end
end
addCommand("real",:realnamecmd,"Return the realname of a user.")
def usernamecmd(args="",nick="",chan="",rawargs="",pipeargs=""))
	user=nick
	if not args.empty? then
		nick=args.split(" ").first
	end
	if m=@passivedata["users"][user] then
		return m["user"] or "No such record."
	else
		return "No data on User #{user}."
	end
end
addCommand("user",:usernamecmd,"Return the username of a user.")
def accnamecmd(args="",nick="",chan="",rawargs="",pipeargs=""))
	user=nick
	if not args.empty? then
		nick=args.split(" ").first
	end
	if m=@passivedata["users"][user] then
		return m["acc"] or "No such record."
	else
		return "No data on User #{user}."
	end
end
addCommand("acc",:accnamecmd,"Return the Accountname of a user.")
def servernamecmd(args="",nick="",chan="",rawargs="",pipeargs=""))
	user=nick
	if not args.empty? then
		nick=args.split(" ").first
	end
	if m=@passivedata["users"][user] then
		return m["server"] or "No such record."
	else
		return "No data on User #{user}."
	end
end
addCommand("server",:servernamecmd,"Return the Servername of a user.")

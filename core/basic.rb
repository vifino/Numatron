# Core Commands here.
# Made by vifino
def echo(args,nick,chan)
	return args
end
$commands["echo"] = "echo"
$commands["say"] = "echo"
def rb(args,nick,chan)
	if isPrivileged? nick and args != nil then
		begin
			returnval = eval args
			if returnval!=nil then
				#@bot.msg(chan,"=> "+ returnval.inspect)
				return returnval
			end
		rescue Exception => detail
			@bot.msg(chan,detail.message())
		end
	end
end
$commands["rb"] = "rb"
def raw(args,nick,chan)
	if isPrivileged(nick) then
		@bot.send(args)
	end
end
$commands["raw"] = "raw"
def join(args,nick,chan)
	if isPrivileged? nick then
		@bot.join(args)
	end
end
def part(args,nick,chan)
	if isPrivileged? nick then
		@bot.part(args)
	end
end
$commands["join"] = "join"
$commands["part"] = "part"

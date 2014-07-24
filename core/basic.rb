# Core Commands here.
# Made by vifino
def echo(args,nick,chan,rawargs="",pipeargs="")
	return args
end
$commands["echo"] = :echo
$commands["say"] = :echo
def rb(args,nick,chan,rawargs="",pipeargs="")
	if isPrivileged? nick and args != nil then
		begin
			returnval = eval args
			if returnval!=nil then
				#@bot.msg(chan,"=> "+ returnval.inspect)
				return (returnval.inspect or "nil")
			end
		rescue => detail
			#@bot.msg(chan,detail.message())
			return detail.message()
		end
	end
end
$commands[">>"] = :rb
def cmd_append(args,nick,chan,rawargs="",pipeargs="")
	return (pipeargs or "")+(rawargs or "")
end
$commands["append"] = :cmd_append
def raw(args,nick,chan,rawargs="",pipeargs="")
	if isPrivileged(nick) then
		@bot.send(args)
	end
end
$commands["raw"] = :raw
def join(args,nick,chan,rawargs="",pipeargs="")
	if isPrivileged? nick then
		@bot.join(args)
	end
end
def part(args,nick,chan,rawargs="",pipeargs="")
	if isPrivileged? nick then
		@bot.part(args)
	end
end
$commands["join"] = :join
$commands["part"] = :part

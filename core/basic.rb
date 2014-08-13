# Core Commands here.
# Made by vifino
$commands["say"] = $commands["echo"] =->(args,nick,chan,rawargs="",pipeargs=""){args}
def rb(args,nick,chan,rawargs="",pipeargs="")
	if isPrivileged? nick and args != nil then
		begin
			returnval = eval args.to_s
				return (returnval.inspect or "nil")
		rescue Exception => detail
			#@bot.msg(chan,detail.message())
			return detail.message
		end
	end
end
$commands[">>"] = :rb
def cmd_append(args,nick,chan,rawargs="",pipeargs="")
	return (pipeargs.to_s or "")+(rawargs.to_s or "")
end
$commands["append"] = :cmd_append
def raw(args,nick,chan,rawargs="",pipeargs="")
	if isPrivileged? nick then
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
$commands["inspect"]=->(args,nick,chan,rawargs="",pipeargs=""){args.inspect}
$commands["type"]=->(args,nick,chan,rawargs="",pipeargs=""){args.class}
$commands["class"]=$commands["type"]
$commands["void"]=""
$commands["string"]=->(args,nick,chan,rawargs="",pipeargs=""){args.to_s}
$commands["array"]=->(args,nick,chan,rawargs="",pipeargs=""){if not args.class==Array then;[args];else;args;end;}

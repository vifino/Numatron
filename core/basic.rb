# Core Commands here.
# Made by vifino
addCommand("say",->(args,nick,chan,rawargs="",pipeargs=""){args},"Returns the input.")
addCommand("echo",->(args,nick,chan,rawargs="",pipeargs=""){args},"Returns the input.")
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
addCommand(">>",:rb,"Executes Ruby code, Admin only!")
def cmd_append(args,nick,chan,rawargs="",pipeargs="")
	return (pipeargs.to_s or "")+(rawargs.to_s or "")
end
addCommand("append",:cmd_append,"Appends a string to the end of the last output.")
def raw(args,nick,chan,rawargs="",pipeargs="")
	if isPrivileged? nick then
		@bot.send(args)
	end
end
addCommand("raw",:raw,"Send raw data to the server, Admin only!")
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
addCommand("join",:join,"Joins a channel, Admin only!")
addCommand("part",:part,"Parts a channel, Admin only!")
addCommand("inspect",->(args,nick,chan,rawargs="",pipeargs=""){args.inspect},"Inspects the input.")
addCommand("type",->(args,nick,chan,rawargs="",pipeargs=""){args.class},"Returns the type of the input")
addCommand("type",$commands["type"],"Returns the type of the input")
addCommand("void","","Replaces every input with an empty string.")
addCommand("string",->(args,nick,chan,rawargs="",pipeargs=""){args.to_s},"Stringifies the input")
addCommand("array",->(args,nick,chan,rawargs="",pipeargs=""){if not args.class==Array then;[args];else;args;end;},"Puts the input in an array, if not already.")

# Core Commands here.
# Made by vifino
def say(args,nick,chan)
	#@bot.msg(chan,"> "+args)
	return args
end
@commands["say"] = "say"
def rb(args,nick,chan)
	if (isPrivileged nick) and args != nil then
		job_rb = fork do
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
		Process.detach(job_rb)
		return nil
	end
end
@commands["rb"] = "rb"
def raw(args,nick,chan)
	return true if nick == "vifino"
end
@commands["raw"] = "raw"

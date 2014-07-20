require 'rufus-lua'
@luastate = Rufus::Lua::State.new
def lua(args,nick,chan)
	if (isPrivileged nick) and args != nil then
		job_lua = fork do
			begin
				returnval = @luastate.eval(args)
				if returnval!=nil then
					#@bot.msg(chan,"> "+ returnval.inspect)
					return returnval.inspect
				end
			rescue => detail
				#@bot.msg(chan,detail.message())
				return detail.message
			end
		end
		Process.detach(job_lua)
	end
end
@commands["lua"] = :lua

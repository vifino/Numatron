require 'rufus-lua'
@luastate = Rufus::Lua::State.new
def lua(args,nick,chan)
	if isPrivileged? nick and args != nil then
		begin
			returnval = @luastate.eval(args)
			if returnval!=nil then
				#@bot.msg(chan,"> "+ returnval.inspect)
				if returnval.class == "Array" then
					return "[table]"
				end
				return returnval.inspect
			end
		rescue => detail
			#@bot.msg(chan,detail.message())
			return detail.message
		end
	end
end
$commands["lua"] = "lua"

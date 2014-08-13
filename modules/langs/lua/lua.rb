# Admin Lua
# Made by vifino
require 'rufus-lua'
@luastate = Rufus::Lua::State.new
@returnval = []
def luaOld(args,nick,chan,rawargs="",pipeargs="")
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
def lua(args, nick, chan,rawargs="",pipeargs="")
	@returnval = []
	if args != nil then
		begin
			@returnval = @luastate.eval(args.to_s)
		rescue => detail
			error = detail.message()
			begin
				@returnval = @luastate.eval("return (" + args.to_s + ")")
			rescue => detail2
			end
		end
		if @returnval != nil or not @output.empty? then
			return @returnval
		elsif error
			return error
		end
	end
end
addCommand("alua",:lua,"Run Lua code without sandbox, Admin only!")

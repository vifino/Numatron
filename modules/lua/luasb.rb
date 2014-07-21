# LuaSB
# Made by Sorroko and vifino
def luasb_reset(args="",nick="",chan="")
	@output = ""
	@luasb = Rufus::Lua::State.new
	@luasb.function 'print' do |string|
		@output << string.to_s
	end
	@luasb.eval(
		"(function() local e = error;" +
		"debug.sethook(function() e(\"Quota exceeded\", 3) end, \"\", 500000) " +
		"io = nil;  os = nil; require = nil; module = nil; dofile = nil; loadfile = nil; package = nil; debug = nil; " +
		"end)()")
	@luasb[:to_ruby] = false
end
luasb_reset
def luasb(args, nick, chan)
	if args != nil then
		begin
			returnval = @luastate.eval(args)
		rescue => detail
				error = detail.message()
				begin
					returnval = @luastate.eval("return (" + args + ")")
				rescue => detail2
				end
		end
					#$bot.irc.msg(chan, detail.message())
		if returnval != nil or not @output.empty? then
			if returnval != nil and returnval!= "" then
				if not returnval.class == "Array" then
					return "[table]"
				end
				return returnval
			end
			if not @output.empty? then
				$bot.irc.msg(chan, "> " + @output)
			end
		elsif error
			@bot.msg(chan,error)
		end
		@output = ""
	end
end
$commands["luasb"] = "luasb"
$commands["resetlua"] = "luasb_reset"

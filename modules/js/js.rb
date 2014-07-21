# Add js interpreter
# Made by vifino
require 'v8'
#@jsstate = V8::Context.new
def js_reset(args,nick,chan)
	@jsstate = V8::Context.new(timeout: 700)
end
#$commands["resetjs"] = "js_reset"
def js(args,nick,chan) # Considered safe? I hope so.
	#if isPrivileged? nick and args != nil then
		begin
			#returnval = @jsstate.eval(args)
			js = V8::Context.new timeout: 700
			returnval = js.eval(args)
			if returnval!=nil then
				if not returnval.class == "Array" then
					return "[object Object]"
				end
				return returnval.inspect
			end
		rescue => detail
			return detail.message
		end
	#end
end
$commands["js"] = "js"

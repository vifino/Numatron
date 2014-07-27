# Add js interpreter
# Made by vifino
require 'v8' # Rawr! Fancy!
#@jsstate = V8::Context.new
def js(args,nick,chan,rawargs="",pipeargs="") # Considered safe? I hope so.
	#if isPrivileged? nick and args != nil then
		begin
			#returnval = @jsstate.eval(args)
			js = V8::Context.new timeout: 700
			returnval = js.eval(args)
			if returnval!=nil then
				if returnval.class == "Array" then
					return "[object Object]"
				end
				return returnval.inspect
			end
		rescue => detail
			return detail.message
		end
	#end
end
$commands["js"] = :js

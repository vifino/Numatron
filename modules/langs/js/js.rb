# Add an js interpreter
# Made by vifino
require 'v8' # Rawr! Fancy!
@jsvm = V8::Context.new timeout: 700 # Vrooom! Vrooooom! And stop.
@jsout = ""
def jsinit
	@jsvm["print"] = lambda {|this, word| @jsout << word.to_s }
end
jsinit
def js(args="",nick="",chan="",rawargs="",pipeargs="") # Considered safe? I hope so.
	@jsout = ""
	begin
		returnval = @jsvm.eval(args)
		if returnval!=nil then
			if returnval.class == "Array" then
				return "[object Object]"
			end
			if @jsout.empty? then
				return returnval.inspect
			else
				return @jsout.strip+"\n> "+returnval.inspect
			end
		end
	rescue => detail
		return detail.message
	end
end
$commands["js"] = :js

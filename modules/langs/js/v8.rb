# Add an js inter# Add an js interpreter
# Made by vifino
if not @jruby then
	require 'v8' # Rawr! Fancy!
	@jsvm = V8::Context.new timeout: 700 # Vrooom! Vrooooom! And stop.
	@jsout = ""
	def jsinit
		@jsvm["print"] = lambda {|this, word| @jsout << word.to_s + " "; return word.to_s}
		@jsvm["log"] = lambda {|this, word| @jsout << word.to_s + " "; return word.to_s}
		@jsvm["write"] = lambda {|this, word| @jsout << word.to_s; return word.to_s}
		@jsvm["console"]={}
		@jsvm["console"]["log"] = lambda {|this, word| @jsout << word.to_s; return word.to_s}
		@jsvm["Math"]["random"] = lambda {|this| return rand}
	end
	jsinit
	def js(args="",nick="",chan="",rawargs="",pipeargs="") # Considered safe? I hope so.
		@jsout = ""
		begin
			returnval = @jsvm.eval(args)
			if returnval!=nil then
				if returnval.class == "Array" or returnval.class==V8::Object then
					returnval="[object Object]"
				elsif returnval.class==V8::Function then
					returnval="[Function]"
				end
			end
			if @jsout.empty? then
				return returnval.inspect
			else
				txt = ""
				if returnval!=nil then
					txt = "\n> "+returnval.inspect
				end
				return @jsout.strip+txt
			end
		rescue => detail
			return detail.message
		end
	end
	$commands["js"] = :js
end

# Brainfuck interpreter, ported to ruby
# Made by vifino
require 'timeout'
def bf(insts,input="")
	if not insts.empty? then
		code = "o='';p=0;a=[];"
		insts.strip.split("").each {|inst|
			code +="if p<=0 then p=0; end;if !a[p] then a[p]=0; end;if a[p]<=0 then a[p]=0; end;"
			if inst==">" then
				code += "p+=1;"
			elsif inst=="<" then
				code += "p-=1;"
			elsif inst=="+" then
				code += "a[p]+=1;"
			elsif inst=="-" then
				code += "a[p]-=1;"
			elsif inst=="." then
				code += "o+=a[p].chr;"
			elsif inst=="["
				code += "if a[p]!=0 then; until a[p]<=1 do;"
			elsif inst=="]" then
				code += "end;end;"
			end
		}
		code +="return o;"
		puts code
		begin
			out=eval(code)
			return out
		rescue => e
			puts e
			return "Error"
		end
	end
end
def bf_cmd(args="",nick="",chan="",rawargs="",pipeargs="")
	begin
  	Timeout::timeout(2) do
    return bf(args,pipeargs)
  end
rescue => e
  	return "Error: Took too long."
	end
end
$commands["bf"] = :bf_cmd

# Brainfuck interpreter, ported to ruby
# Made by vifino
require 'timeout'
def bf(insts,input="") # not working fully, but most part is working.
	if not insts.empty? then
		code = "o='';p=0;w=p;a=[];"
		insts.strip.split("").each {|inst|
			code +="if p<=0 then p=0; end;if a[p]==nil then a[p]=0; end;if a[p]==-1 then a[p]=0; end;"
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
				code += "w=p;while a[w]!=0 do;p=0;"
			elsif inst=="]" then
				code += "end;w=p;"
			end
		}
		code +="if p<=0 then p=0; end;if a[p]==nil then a[p]=0; end;if a[p]==-1 then a[p]=0; end;"
		code +="return o;"
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
    	return bf(args,pipeargs).delete("\r\n")
		end
	rescue => e
  	return "Error: Took too long."
	end
end
$commands["bf"] = :bf_cmd
$commands["brf"] = :bf_cmd
$commands["brainfuck"] = :bf_cmd
def bfopt(code)
	optimised = ""
	optimised = code.gsub(/[^\+\-<>\[\]\.,]/i, '')
	# tbd
	return optimised.strip
end
def blf2brf(code) # Boolfuck to brainfuck :3
	code=code.gsub('>[>]+<[+<]>>>>>>>>>[+]<<<<<<<<<',"+").gsub('>>>>>>>>>+<<<<<<<<+[>+]<[<]>>>>>>>>>[+]<<<<<<<<<',"-") # + and -
	code=code.gsub('<<<<<<<<<',"<").gsub('>>>>>>>>>',">") # > and <
	code=code.gsub('>,>,>,>,>,>,>,>,<<<<<<<<',",").gsub('>;>;>;>;>;>;>;>;<<<<<<<<',".") # Input and output
	code=code.gsub('>>>>>>>>>+<<<<<<<<+[>+]<[<]>>>>>>>>>[+<<<<<<<<[>]+<[+<]',"[").gsub('>>>>>>>>>+<<<<<<<<+[>+]<[<]>>>>>>>>>]<[+<]',"]") # [ and ]
	return code
end
def brf2blf(code) # Boolfuck to brainfuck, reversed! :D
	code=code.gsub(/\+/,'>[>]+<[+<]>>>>>>>>>[+]<<<<<<<<<').gsub(/\-/,'>>>>>>>>>+<<<<<<<<+[>+]<[<]>>>>>>>>>[+]<<<<<<<<<') # + and -
	code=code.gsub(/</,'<<<<<<<<<').gsub(/>/,'>>>>>>>>>') # > and <
	code=code.gsub(/,/,'>,>,>,>,>,>,>,>,<<<<<<<<').gsub(/\./,'>;>;>;>;>;>;>;>;<<<<<<<<') # Input and output
	code=code.gsub(/\[/,'>>>>>>>>>+<<<<<<<<+[>+]<[<]>>>>>>>>>[+<<<<<<<<[>]+<[+<]').gsub(/\[/,'>>>>>>>>>+<<<<<<<<+[>+]<[<]>>>>>>>>>]<[+<]') # [ and ]
	return code
end
$commands["brf2blf"] = :brf2blf
$commands["brainfuck2boolfuck"] = :brf2blf
$commands["blf2brf"] = :blf2brf
$commands["boolfuck2brainfuck"] = :blf2brf
def blf_cmd(args="",nick="",chan="",rawargs="",pipeargs="")
	begin
		Timeout::timeout(2) do
			return bf(blf2brf(args),pipeargs).delete("\r\n")
		end
	rescue => e
		return "Error: Took too long."
	end
end
$commands["bf"] = :blf_cmd
$commands["blf"] = :blf_cmd
$commands["boolfuck"] = :blf_cmd

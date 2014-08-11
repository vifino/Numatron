# Swizzle interpreter, a custom esolang, wip
# Made by vifino
require 'timeout'
def swizzle(insts,input="")
	str="o='';a=Array.new(256,0);p=0;i=0;"#;cn=0;co=0;"
	insts.downcase.gsub(/./){|inst|
		str = str+"i=i||0;if i>=256 then;i=0;end;if i<0 then;i=255; end;"
		case inst
		when "+"
			str+="i+=1;"
		when "-"
			str+="i-=1;"
		when ">"
			str+="p+=1;"
		when "<"
			str+="p-=1;"
		when "."
			str+="o+=i.chr;"
		when ";"
			str+="o+=i.to_s;"
		when "["
			str+="while i>0 do;"
		when "]"
			str+="end;"
		when "("
			str+="if a[p]==i then;"
		when ")"
			str+="end;"
		#when "["
		#	str+="co=cn;cn=a[p];until cn>0 do;cn-=1;"
		#when "]"
		#	str+="end;cn=co;"
		when "!"
			str+="a[p]=i;"
		when "#"
			str+="i=a[p]||0;"
		when "^"
			str+="i=i**2;"
		when "d"
			str+="i+=i;"
		when ","
			str+="if c=input[0] then;i=c.ord;else;i=0;end;input=input[1..-1];"
		end
	}
	str+="o;"
	#puts str
	begin
		eval str
	rescue SyntaxError => e
		puts e.to_s
		return "Syntax Error."
	end
end
def sw_cmd(args="",nick="",chan="",rawargs="",pipeargs="")
	begin
		Timeout::timeout(2) do
			ret=swizzle(args,pipeargs)
			return (ret or "").delete("\r\n")
		end
		if ret.class == String
		else
			"Error: Took too long."
		end
	rescue => e
		puts e.to_s
		return "Error: Took too long."
	end
end
$commands["swz"] = :sw_cmd
$commands["swizzle"] = :sw_cmd

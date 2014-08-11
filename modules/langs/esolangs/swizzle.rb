# Swizzle interpreter, a custom esolang, wip
# Made by vifino
require 'timeout'
def swizzle(insts,input="")
	str="o='';a=Array.new(256,0);p=0;i=0"#;cn=0;co=0;"
	insts.gsub(/./){|inst|
		str = str+"i=i||0;if cn<=0 then;cn=0;end;if i>=256 then;i=0;end;if i<0 then;i=255; end;"
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
		#when "["
		#	str+="co=cn;cn=a[p];until cn>0 do;cn-=1;"
		#when "]"
		#	str+="end;cn=co;"
		when "!"
			str+="a[p]=i;"
		when "#"
			str+="i=a[p];"
		when "^"
			str+="i=i**2;"
		when "d"
			str+="i+=i;"
		end
	}
	str+="return o;"
	#puts str
	begin
		eval str
	rescue => e
		puts e
		return "Error."
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

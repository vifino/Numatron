# Deadfish interpreter, ported to ruby
# Made by vifino
require 'timeout'
def deadfish(insts)
	str="o='';i=0;"
	insts.gsub(/./){|inst|
		str = str+"if i>=256 then;i=0; end;if i<0 then; i=255; end;"
		case inst
		when "i"
			str+="i+=1;"
		when "d"
			str+="i-=1;"
		when "o"
			str+="o+=i.chr;"
		when "s"
			str+="i=i*i;"
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
def df_cmd(args="",nick="",chan="",rawargs="",pipeargs="")
		begin
			Timeout::timeout(2) do
				ret=deadfish(args)
				return (ret or "").delete("\r\n")
			end
		if ret.class == String
		else
			"Error: Took too long."
		end
	rescue SyntaxError => e
		puts e.to_s
		return "Error: Took too long."
	end
end
$commands["df"] = :df_cmd
$commands["deadfish"] = :df_cmd

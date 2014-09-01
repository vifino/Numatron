# Swizzle interpreter, a custom esolang, wip
# Made by vifino
require 'timeout'
def swizzle(insts,input="")
	str="o='';a=Array.new(256,0);p=0;i=0;"#;cn=0;co=0;"
	insts.downcase.gsub(/./){|inst|
		str = str+"if i>=256 then;end;if i<0 then;i=255; end;"
		case inst
			when "+"# Add
				str+="i+=1;"
			when "-" # Substract
				str+="i-=1;"
			when ">" # Increase pointer
				str+="p+=1;"
			when "<"# Decrease pointer
				str+="p-=1;"
			when "." # Write char
				str+="o+=i.chr;"
			when ";" # Write number
				str+="o+=i.to_s;"
			when "[" # While
				str+="while i>0 do;"
			when "]" # End
				str+="end;"
			when "=" # If tape and workcell are the same, set workcell to 1, else 0.
				str+="if a[p]==i then;i=1;else;i=0;end;"
			when "?" # Same as = but reversed.
				str+="if a[p]==i then;i=0;else;i=1;end;"
			when "(" # If higher than 1
				str+="if i>=1 then;"
			when ")" # End
				str+="end;"
			#when "["
			#	str+="co=cn;cn=a[p];until cn>0 do;cn-=1;"
			#when "]"
			#	str+="end;cn=co;"
			when "!" # Write workcell to tape
				str+="a[p]=i;"
			when "#" # Read tape
				str+="i=a[p]||0;"
			when "^" # Square
				str+="i=i**2;"
			when "d" # Dupe
				str+="i+=i;"
			when "h" # Half
				str+="i=i/2;"
			when "," # Read from input
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
			ret=swizzle(args.to_s,pipeargs.to_s)
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
addCommand("swz",:sw_cmd,"Run Swizzle code.")
addCommand("swizzle",:sw_cmd,"Run Swizzle code.")
def swrel(goal,i)
	out=""
	lastinst=""
	while i!=goal do
		rel=goal-i
		if rel>0 then # positive
			if rel > (goal-(i*i)) and (goal-(i*i))>=(goal-(i+i)) then # if i^2 is closer to goal then normal i and closer than that below
				out+="^"
				i=i*i
				lastinst="^"
			elsif rel.abs>(goal-(i+i)).abs and (goal-(i/2)).abs>(goal-(i+i).abs) then
				puts "d"
				puts goal
				puts i
				puts (goal-(i+i))
				puts rel
				out+="d"
				i+=i
				lastinst="d"
			else
				out+="+"
				i+=1
				lastinst="+"
			end
		elsif rel<0 then # negative
			if (goal-(i/2)).abs>rel.abs and (goal-(i/2)).abs<(goal-(i+i).abs) then
				puts "h"
				puts goal
				puts i
				puts (goal-(i/2))
				puts rel
				out+="h"
				i=i/2
				lastinst="h"
			else
				out+="-"
				i-=1
				lastinst="-"
			end
		else
			break # If this case ever comes...
		end
	end
	return out,i
end
def swencode(txt)
	i=0
	out=""
	txt.gsub /./ do |char|
		c=char.ord
		o,i=swrel(c,i)
		out+=o+"."
	end
	return out+"+[-]"
end
addCommand("swzenc",->(args="",nick="",chan="",rawargs="",pipeargs=""){swencode(args.to_s)},"Encode a string to Swizzle code.")
addCommand("swizzleencoder",->(args="",nick="",chan="",rawargs="",pipeargs=""){swencode(args.to_s)},"Encode a string to Swizzle code.")

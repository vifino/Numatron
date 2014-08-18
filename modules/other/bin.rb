# String to binary and back
# Made by vifino
def str2bin(inp="")
	out=[]
	inp=inp.to_s
	inp.split("").each {|c|
		binrep=c.ord.to_s(2)
		unless binrep.length==8 then
			binrep="0"+binrep
		end
		out.push binrep
	}
	out.join " "
end
addCommand("tobin",->(args="",nick="",chan="",rawargs="",pipeargs=""){str2bin args},"Convert strings to binary strings.")
def bin2str(inp)
	str=inp.strip.gsub(/([^10])/,"")
	str.gsub(/......../){|binrep|
		#puts binrep.to_i(2)
		begin
			binrep.to_i(2).chr
		rescue => e
			puts e
			""
		end
	}
end
addCommand("frombin",->(args="",nick="",chan="",rawargs="",pipeargs=""){bin2str args},"Convert binary strings to normal strings.")

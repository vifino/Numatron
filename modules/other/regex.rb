# Allows regex commands to be used in commands
# Made by vifino
def regex_cmd(args="",nick="",chan="",rawargs="",pipeargs="")
	if not pipeargs.to_s.empty? and not rawargs.to_s.empty? then
		if match=rawargs.to_s.match(/s\/(.*)\/(.*)\/g/) then
			data=pipeargs.to_s.gsub(/#{match[1]}/,"#{match[2]}")
		elsif match=rawargs.to_s.match(/s\/(.*)\/(.*)\//) or match=rawargs.to_s.match(/s\/(.*)\/(.*)/) then
			data=pipeargs.to_s.sub(/#{match[1]}/,"#{match[2]}")
		elsif match=rawargs.to_s.match(/tr\/(.*)\/(.*)\//) or match=rawargs.to_s.match(/tr\/(.*)\/(.*)/) then
			data=pipeargs.to_s.tr("#{match[1]}","#{match[2]}")
		end
		return data.to_s
	end
end
addCommand("regex",:regex_cmd,"Apply regex actions to the output of the last command. ( Use piping! )")

# Execute shell commands
# Made by vifino
def sh(args="")
	if not args.to_s.empty? then
		return `#{args} 2>&1`
	end
end
def shcmd(args="",nick="",chan="",rawargs="",pipeargs=nil)
	if isPrivileged? nick then
		if pipeargs==nil then
			return sh(args.to_s)
		else
			rnd= ('a'..'z').to_a.shuffle[0,8].join
			tmpfile="/tmp/#{rnd}"
			`touch /tmp/sh_#{rnd}`
			f=File.open "/tmp/sh_#{rnd}","w"
			f.write pipeargs
			f.close
			return sh("cat /tmp/sh_#{rnd}|#{args}")
		end
	else
		return "Errrr.... No?"
	end
end
addCommand("sh",:shcmd,"Execute shell commands, Admin only!")

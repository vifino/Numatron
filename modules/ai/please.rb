# pls pls
addCommand("please",->(args="",nick="",chan="",rawargs="",pipeargs="") {
	if isPrivileged? nick then
		req = args.split(' ', 2)
		if req.empty? then
			return "PLEASE WHAT?!"
		end
		act = req.first
		rst = req.last
		@bot.action("#{req}s #{rst.strip}")
		return nil
	else
		"No! >:D"
	end
}, "You might get what you want if you ask nice.")

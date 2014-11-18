# Google things :D
# Made by vifino

@Google = Google.new
addCommand("gis",->(args,nick,chan,rawargs="",pipeargs=""){
	if args.empty?
		return "Can't search for nothing!"
	else
		@Google.image(args)
	end
}, "Search google for images.")

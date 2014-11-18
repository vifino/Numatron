# Google things :D
# Made by vifino

addCommand("gis",->(args,nick,chan,rawargs="",pipeargs=""){
	if args.empty?
		return "Can't search for nothing!"
	else
		image(args)
	end
}, "Search google for images.")

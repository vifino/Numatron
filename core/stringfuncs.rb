# Commands for text modification
# Made by vifino
def cmd_sqeeze(args,nick,chan,rawargs="",pipeargs="")
	return (args.to_s or "").squeeze
end
addCommand("sqeeze",:cmd_sqeeze,"Replaces double characters with one.")
def cmd_rainbow(args,nick,chan,rawargs="",pipeargs="") # seems broken, I dont know why...
	if not args.to_s.empty? then
		c=rand(colors.length-1)
		colors=["05","07","08","09","10","12","06"] # color is "\u0003<val>""
		str = ""
		args.to_s.lstrip.split("").each {|char|
			if c==colors.length then c=0 end
  		str+="\u0003"+colors[c]+char
			c+=1
		}
		return str+"\u000F"
	end
end
addCommand("rainbow",:cmd_rainbow,"RAAAAINBOW!!!")
def cmd_underline(args,nick,chan,rawargs="",pipeargs="")
	return "\u001F"+args.to_s+"\u000F"
end
addCommand("underline",:cmd_underline,"Underline the input.")
def aeiou(args="",nick="",chan="",rawargs="",pipeargs="")
	return args.to_s.gsub('U','A').gsub('O','U').gsub('I','O').gsub("E","I").gsub('A','E').gsub('u','a').gsub('o','u').gsub('i','o').gsub('e','i').gsub('a','e')
end
addCommand("aeiou",:aeiou,"Riplecis Vuwils with shoftid unis.") # yes. yes.

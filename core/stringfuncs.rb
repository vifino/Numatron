# Commands for text modification
# Made by vifino
def cmd_sqeeze(args,nick,chan,rawargs="",pipeargs="")
	return (args.to_s or "").squeeze
end
addCommand("sqeeze",:cmd_sqeeze,"Replaces double characters with one.")
def cmd_rainbow(args,nick,chan,rawargs="",pipeargs="")
	if not args.to_s.empty? then
		colors=["05","07","08","09","10","12","06"] # color is "\u0003<val>""
		c=rand(colors.length-1)
		str = ""
		args.to_s.lstrip.split("").each {|char|
			if c==colors.length then c=0 end
  		str+="\u0003"+colors[c]+char
			c+=1
		}
		return str+"\u000F"
	end
end
addCommand("rainbow",:cmd_rainbow,"\u000308R\u000309A\u000310A\u000312A\u000306A\u000305I\u000307N\u000308B\u000309O\u000310W\u000312!\u000306!\u000305!\u000F") # surprise, surprise!
def cmd_underline(args,nick,chan,rawargs="",pipeargs="")
	return "\u001F"+args.to_s+"\u000F"
end
def cmd_rainwords(args,nick,chan,rawargs="",pipeargs="")                                   
        if not args.to_s.empty? then
                colors=["05","07","08","09","10","12","06"] # color is "\u0003<val>""
                c=rand(colors.length-1)
                str = ""
                args.to_s.lstrip.split(" ").each {|char|
                        if c==colors.length then c=0 end
                str+="\u0003"+colors[c]+char
                        c+=1
                }
                return str+"\u000F"
        end
end
addCommand("rainwords",:cmd_rainwords,"\u000308R\u000309A\u000310A\u000312A\u000306A\u000305I\u000307N\u000308B\u000309O\u000310W\u000312!\u000306$")
addCommand("underline",:cmd_underline,"Underline the input.")
def aeiou(args="",nick="",chan="",rawargs="",pipeargs="")
	#return args.to_s.gsub('U','A').gsub('O','U').gsub('I','O').gsub("E","I").gsub('A','E').gsub('u','a').gsub('o','u').gsub('i','o').gsub('e','i').gsub('a','e')
	return args.to_s.tr 'aeiouAEIOU','eiouaEIOUA'
end
addCommand("aeiou",:aeiou,"Riplecis Vuwils woth shoftid unis.") # yes. yes.

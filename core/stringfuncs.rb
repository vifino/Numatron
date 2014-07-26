# Commands for text modification
# Made by vifino
def cmd_sqeeze(args,nick,chan,rawargs="",pipeargs="")
	return (args or "").squeeze()
end
$commands["sqeeze"] = :cmd_sqeeze
def cmd_rainbow(args,nick,chan,rawargs="",pipeargs="") # seems broken, I dont know why...
	if not args.empty? then
		colors=["04","07","08","03","02","12","06","04","07"] # color is "\u0003<val>""
		str = ""
		c=0
		args.split("").each {|char|
			c+=1
			if c == 8 then c=0 end
  		str+="\u0003"+colors[c]+char+"\u000F"
		}
		return str
	end
end
$commands["rainbow"] = :cmd_rainbow
def cmd_underline(args,nick,chan,rawargs="",pipeargs="")
	return "\u001F"+args+"\u000F"
end
$commands["underline"] = :cmd_underline

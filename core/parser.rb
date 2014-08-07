# The command Parser
# Made by vifino
$commands ||= Hash.new()
$variables ||= Hash.new()
def argParser(args="",nick,chan)
	$variables["nick"]=nick
	$variables["chan"]=chan
	$variables["channel"]=chan
	#args=args.gsub(/\$<(.*?)>/) {|var|
	args=args.gsub(/<(.*?)>/) {|var=""|
		if not var.empty? then
			nme=(var or "< >").strip.gsub(/^</,"").gsub(/>$/,"")#.split(" ")[0]
			"<>" if (nme or "").empty?
			if $variables[nme] then
				return $variables[nme.downcase] if not $variables[nme.downcase]==""
				return var
			else
				return var
			end
		end
	}
	args=args.gsub(/\${(.*)}/) {|cmdN|
		if not cmdN.empty? then
			commandRunner((cmdN.strip.gsub("${","").gsub("}","") or cmdN), nick, chan)
		end
	}
end

def commandRunner(cmd,nick,chan)
	cmd=cmd.strip
	retFinal=""
	retLast=""
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	retLast=rnd
	cmdarray = cmd.scan(/(?:[^|\\]|\\.)+/) or [cmd]
	#func, args = cmd.lstrip().split(' ', 2)
	cmdarray.each {|cmd|
		cmd=cmd.lstrip
		if cmd then
			cmd = cmd.gsub("\\|","|")
			func, args = cmd.split(' ', 2)
			args = argParser((args or ""),nick,chan)
			func=func.downcase()
			if $commands[func] then
				if retLast==rnd then
					retLast = ""
					if $commands[func].is_a?(Method) then
						retLast = $commands[func].call(args, nick, chan, args, "")
						retLast = retLast.to_s or ""
					elsif $commands[func].class == Proc then
						retLast = $commands[func].call(args, nick, chan, args, "")
						retLast = retLast.to_s or ""
					elsif $commands[func].class == String then
						retLast = $commands[func] or ""
					elsif $commands[func].class == Symbol then
						retLast = self.send($commands[func], args, nick, chan, args, "")
						retLast = retLast.to_s or ""
					end
				else
					if $commands[func].is_a?(Method) then
						retLast = $commands[func].call(args, (args or "")+retLast, chan, args, retLast)
						retLast = retLast.to_s or ""
					elsif $commands[func].class == Proc then
						retLast = $commands[func].call(args, (args or "")+retLast, chan, args, retLast)
						retLast = retLast.to_s or ""
					elsif $commands[func].class == String then
							retLast = $commands[func] or ""
					elsif $commands[func].class == Symbol then
						retLast = self.send($commands[func], (args or "")+retLast, nick, chan, args, retLast)
						retLast = retLast.to_s or ""
					end
				#retLast=self.send(@commands[func],(args or "")+retLast,nick,chan) or ""
				end
			else
				if @cmdnotfound then
					retLast = "No such function: '#{func}'"
				end
				break
			end
		end
	}
	return retLast.rstrip if not (retLast==rnd or (retLast.to_s or "").empty?)
end
def commandParser(cmd,nick,chan) # This is the entry point.
	#job_parser = fork do
	Thread.new do
		begin
			ret=commandRunner(cmd, nick, chan)
			if ret then
				if ret.length > 200 then
					@bot.msg(chan,"> Output: "+putHB(ret.to_s))
				else
					@bot.msg(chan,"> "+ret.to_s)
				end
			end
		rescue => detail
			@bot.msg(chan,detail.message())
		end
		#exit
	end
	#Process.detach(job_parser)
end
$commands["let"]=->(args="",nick="",chan="",rawargs="",pipeargs=""){
	if not args.empty? then
		if data=args.match(/(.*?)=(.*)/) then
			p data
			$variables[data[1].strip.downcase] = data[2].strip
			return "Set Variable '#{data[1].downcase}' to '#{data[2]}'"
		else
			return "Missing input."
		end
	else
		return "Missing input."
	end
}

# Markov Chain, do not use, doesnt work, probably.
# Made by vifino
class Markov
	attr_reader :parts,:startParts
	def initialize()
    @parts = Hash.new # Storage for data
		@startParts = Array.new
  end
	def learn(str="")
		input=str.split(" ")
		if input[1] then
			@startParts.push(input[0]+" "+input[1])
			for i in 0 ...(input.size-1) do
				if input[i+1] then
					part1=input[i].strip
					part2=input[i+1].strip
					#@parts[part1+" "+part2] = (input[1+2] or "")
					@parts[(part1+" "+part2).downcase] ||=[]
					if not @parts[(part1+" "+part2).downcase].include? (input[i+2] or nil) then
						@parts[(part1+" "+part2).downcase].push (input[i+2] or nil)
					end
				end
			end
		end
	end
	def generate()
		start = @startParts.sample
		finished = false
		out = start.downcase
		until finished do
			a = out.split(" ")
			lastPart = a[a.count-2].to_s + " " + a[a.count-1].to_s
			part = nextItem(lastPart)
			if (a[a.count-2].to_s+part.to_s).downcase==lastPart.to_s.downcase then
				return out
			elsif part then
				out = out+" "+part
			else
				return out
			end
		end
	end
	def nextPart(part)
		#@parts[part] = @parts[part] or Array.new()
		#part2=@parts[part].sample or ""
		#part1=part.split(" ")[1]
		#return part1+" "+part2
		if part1=(@parts[part.strip] or [nil]).sample!=nil then
			part1+" "+part.split(" ")[1]
		else
			nil
		end
	end
	def nextItem(part)
		#@parts[part] = @parts[part] or Array.new()
		#part2=@parts[part].sample or ""
		#part1=part.split(" ")[1]
		#return part1+" "+part2
		(@parts[part.downcase.strip] or [nil]).sample
	end
end
@marky||=Markov.new
@markychans||=[]
addCommand("markov",->(args,nick,chan,rawargs="",pipeargs=""){@marky.generate},"Generate a sentence using the Markov Chain.")
def markovhook(raw)
	data= @bot.msgtype(raw)
	type = data[0]
	nick = data[1]
	chan = data[2]
	msg = data[3]
	username = data[4]
	hostname = data[5]
	if type =="msg" and (!isBlacklisted? nick) then
		prefix = @prefix or "\?"
		if not (msg.match(/^#{Regexp.escape(prefix)}(.*)/) or msg.match(/^#{Regexp.escape(@bot.nick)}.(.*)/)) and (!isBlacklisted? nick) then
			@marky.learn(msg) # HUEHUEHUE
		end
	end
end
def markycontrol(args="",nick="",chan="",rawargs="",pipeargs="")
	if isPrivileged? nick then
		args=args.strip
		if args.split(" ").first=="enable" then
			if not @rawhooks.include? :markovhook then
				@rawhooks.push :markovhook
			end
			"Marky enabled! \\o/"
		elsif args.split(" ").first=="disable" then
			@rawhooks.each_with_index {|i,v|
				@rawhooks.pop i if v==:markovhook
			}
			"Disabled!"
		end
	else
		"No permission to control me! D:<"
	end
end
addCommand("markycontrol",:markycontrol,"Control the Markov Chain, Admin only!")

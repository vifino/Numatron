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
		out = start
		until finished do
			a = out.split(" ")
			lastPart = a[a.count-2] + " " + a[a.count-1]
			part = nextItem(lastPart)
			if (a[a.count-2]+part).downcase==lastPart.downcase
			if part then
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
		(@parts[part.strip] or [nil]).sample
	end
end
@marky||=Markov.new
addCommand("markov",->((args,nick,chan,rawargs="",pipeargs=""){(@marky.generate or "No output.")})
def markovhook(raw)
	data= @bot.msgtype(raw)
	type = data[0]
	nick = data[1]
	chan = data[2]
	msg = data[3]
	username = data[4]
	hostname = data[5]
	if type =="msg" and (!isBlacklisted? nick) then
		@marky.learn(msg) # HUEHUEHUE
	end
end
if not @rawhooks.include? :testai then
	@rawhooks.push :testai
end

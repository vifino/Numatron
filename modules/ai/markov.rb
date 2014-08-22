# Markov Chain, do not use, doesnt work
# Made by vifino
class Markov
	attr_reader :parts
	def initialize()
    @parts = Hash.new # Storage for data
		@startParts = Array.new
  end
	def learn(str)
		input=str.split(" ")
		@startParts.push(input[0]+" "+input[1])
		for i in 1 ...(input.size-1) do
			if input[i+1] then
				part1=input[i]
				part2=input[i+1]
				#@parts[part1+" "+part2] = (input[1+2] or "")
				@parts[part1+" "+part2] ||=[]
				if not @parts[part1+" "+part2].include? (input[1+2] or "")  then
					@parts[part1+" "+part2].push (input[1+2] or "") 
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
			lastPart = a[a.count-1] + " " + a[a.count]
			part = nextPart(lastPart)
			if part then
				a=part.split()
				if a[1] then
					out = out+" "+a[1]
				else
					return out
				end
			else
				return out
			end
		end
	end
	def nextPart(part)
		@parts[part] = @parts[part] or Array.new()
		part2=@parts[part].sample or ""
		part1=part.split(" ")[1]
		return part1+" "+part2
	end
end

# fifo crap, doesnt do anything more than the functions that it calls
# Made by vifino
class Fifo # Whole thing completly unnecissary~~
	attr_reader :fifo
	def openMode(name,mode="r")
		if name then
			@fifo = open(name,mode)
		end
	end
	def openWrite(name)
		if name then
			@fifo = open(name,"w+")
		end
	end
	def openRead(name)
		if name then
			@fifo = open(name,"r+")
		end
	end
	def gets
		@fifo.gets
	end
	def puts(txt)
		@fifo.puts txt
	end
	def flush
		@fifo.flush
	end
end

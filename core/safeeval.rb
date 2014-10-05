# Prototype, to make a timeout that really kills things.
require 'timeout'
def safetimeout(sec)
	read, write = IO.pipe
	pid = fork do
		read.close
		Signal.trap("HUP") { exit } 
		begin
			res = yield
			Marshal.dump(res, write)
			exit!(0)
		rescue => e
			Marshal.dump(e, write)
			exit!(0)
		end
	end
	Process.detach pid
	write.close
	#result=read.read
	begin
		Timeout::timeout(sec) do
			puts "Waiting..."
			result=read.read
			#Process.wait pid
			puts "Done! Dumping..."
			raise "Child failed." if result.empty?
			puts "Dumped."
        		return Marshal.load(result)
		end
	rescue => e
		puts "Error"
		Process.kill "HUP",pid
		return e
	end	
end

# Prototype, to make a timeout that really kills things. Maybe. I have no clue.
require 'timeout'
def safetimeout(sec)
	read, write = IO.pipe
	pid = fork do
		read.close
		Signal.trap("HUP") { exit!(0) } 
		begin
			res = yield
			Marshal.dump(res, write)
		rescue => e
			Marshal.dump(e, write)
		ensure
			puts "Exit."
			exit!(0)
		end
	end
	thr = Process.detach pid
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
		Thread.kill thr
		Process.kill "HUP",pid
		return e
	end
rescue => e
	return e	
end

# Adds a CLI to Numatron.
# Made by vifino
def cli_init
	putsbelow "> "
	Thread.new do
		while true do
			#puts ">> "+(commandRunner((gets or ""),@admins.first,"#Console") or "") # I wonder why this even works :P
			#puts ">> "+(rb((gets or ""),@admins.first,"#Console") or "")
			begin
				returnval = eval (gets or "").to_s
				puts ">> "+(returnval.inspect or "nil")
			rescue Exception => detail
				#@bot.msg(chan,detail.message())
				puts ">> "+detail.message
			end
		end
	end
end
cli_init if (STDOUT.tty? and STDIN.tty?)

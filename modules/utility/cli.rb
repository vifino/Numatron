# Adds a CLI to Numatron.
# Made by vifino
def cli_init
	putsbelow "> "
	Thread.new do
		while true do
			puts ">> "+(commandRunner((gets or ""),@admins.first,"#Console") or "") # I wonder why this even works :P
		end
	end
end
cli_init

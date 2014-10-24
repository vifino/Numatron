# Integration of AIML botscripts in Numatron

require 'programr'
aimlfiles = Dir[APP_ROOT+"/modules/ai/*.aiml"]

def aiml(args="",nick="",chan="",rawargs="",pipeargs="")
	return $aiml.get_reaction(args)
end

if not aimlfiles.empty?
	$aiml = ProgramR::Facade.new
	aimlfiles.each do |file|
		begin
			puts "Learning file #{file}..."
			$aiml.learn [file]
			puts "Done!"
		rescue => e
			puts "Error in file #{file}: #{e.to_s}"
		end
	end
	addCommand("ai",:aiml,"Query an AI")
end

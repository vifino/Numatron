# Integration of AIML botscripts in Numatron

require 'programr'
aimlfiles = Dir[APP_ROOT+"/modules/ai/*.aiml"]

def aiml(args="",nick="",chan="",rawargs="",pipeargs="")
	return $aiml.get_reaction(args)
end

if not aimlfiles.empty?
	$aiml = ProgramR::Facade.new
	$aiml.learn aimlfiles
	addCommand("ai",:aiml,"Query an AI")
end

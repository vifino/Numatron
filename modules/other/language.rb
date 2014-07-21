# Language detector, using "Whatlanguage"
# Made by vifino
require 'whatlanguage'
def lang(args,nick,channel)
	return args.language or "Unknown."
end
$commands["lang"] = :lang

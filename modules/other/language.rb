# Language detector, using "Whatlanguage"
# Made by vifino
require 'whatlanguage'
@wl = WhatLanguage.new(:all)
def lang(args,nick,channel,rawargs="",pipeargs="")
	return @wl.language(args.to_s)
end
# $commands["lang"] = :lang
# Disabled because of trolls.

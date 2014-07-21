# Language detector, using "Whatlanguage"
# Made by vifino
require 'whatlanguage'
@wl = WhatLanguage.new(:all)
def lang(args,nick,channel)
	return @wl.language(args)
end
$commands["lang"] = :lang

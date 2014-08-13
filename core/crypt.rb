# Missleading name. Maybe.
# Made by vifino
require "base64"
def base64(args,nick,chan,rawargs="",pipeargs="")
	Base64.encode64(args.to_s)
end
def debase64(args,nick,chan,rawargs="",pipeargs="")
	Base64.decode64(args.to_s)
end
addCommand("b64",:base64,"Base64 encode the input.")
addCommand("deb64",:debase64,"Base64 decode the input.")
addCommand("base64",:base64,"Base64 encode the input.")
addCommand("debase64",:debase64,"Base64 decode the input.")
def rot13(args,nick,chan,rawargs="",pipeargs="")
	args.to_s.tr 'A-Za-z','N-ZA-Mn-za-m'
end
addCommand("rot13",:rot13,"ROT13 the input.")

# Missleading name. Maybe.
# Made by vifino
require "base64"
def base64(args,nick,chan,rawargs="",pipeargs="")
	Base64.encode(args)
end
def debase64(args,nick,chan,rawargs="",pipeargs="")
	Base64.decode(args)
end
$commands["b64"] = :base64
$commands["base64"] = :base64
$commands["deb64"] = :debase64
$commands["debase64"] = :debase64
def rot13(args,nick,chan,rawargs="",pipeargs="")
	args.tr 'A-Za-z','N-ZA-Mn-za-m'
end
$commands["rot13"] = :rot13

# Shorten urls
# Made by vifino
require 'open-uri'
require "cgi"
def shorten(link)
	if link then
		url = "http://"+(link.gsub(/http:\/\//,""))
		if url.is_valid_url? then
			url = CGI.escape(url)
			return open('http://tinyurl.com/api-create.php?url=' + url, {"UserAgent" => "Ruby Script"}).read
		else
			return "Invalid URL"
		end
	else
		return "Can't Shorten Nothing!"
	end
end
def shortenWrapper(addresses,nick,chan,rawargs="",pipeargs="")
	res = []
	if addresses.class==String then
		addrs = addresses.gsub(/\;+$/, '').split(";")
	elsif addresses.class==Array then
		addrs=addresses
	else
		return "Invalid type of input."
	end
	addrs.each {|addr|
		addr = addr.lstrip().rstrip()
		res.push shorten(addr)
	}
	return res
end
addCommand("shorten",:shortenWrapper,"Shorten urls.")

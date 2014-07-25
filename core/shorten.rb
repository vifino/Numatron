# Shorten urls
# Made by vifino
require 'open-uri'
require "cgi"
def shorten(link)
	if link then
		url = "http://"+(link.gsub(/http:\/\//,""))
		if url.is_valid_url? then
			url = CGI.escape(url)
			return open('http://qr.cx/api/?longurl=' + url, {"UserAgent" => "Ruby Script"}).read
		else
			return "Invalid URL"
		end
	else
		return "Can't Shorten Nothing!"
	end
end
def shortenWrapper(addresses,nick,chan,rawargs="",pipeargs="")
	res = ""
	addrs = addresses.gsub(/\;+$/, '').split(";")
	addrs.each {|addr|
		addr = addr.lstrip().rstrip()
		res += shorten(addr)+" ; "
	}
	return res.rstrip.chomp(";")
end
$commands["shorten"] = :shortenWrapper

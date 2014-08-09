# Perform DNS lookups
# Made by vifino
require "dnsruby"
def dns(addr,type="ANY")
	if addr.empty? then return "Can't lookup nothing!" end
	rs = Dnsruby::DNS.new
	begin
		res = rs.getresources(addr, type)
		p res
		if res!=nil then
			return (res.map {|r| r.rdata_to_string.gsub(/[[:cntrl:]]/, '') }).join("; ")
		else
			return "No results!"
		end
	rescue => e
		if e.to_s == "no implicit conversion of nil into Array" then # The URL, that is given, is invalid.
			return "Invalid URL."
		elsif e.class==Dnsruby::NXDomain then
			return "No entries for Domain."
		else
			return (e.to_s or "Error unknown.")
		end
	end
end
def rdns(addr)
	if addr.empty? then return "Can't lookup nothing!" end
	rs = Dnsruby::DNS.new
	begin
		res = rs.getnames addr
		p res
		if res.class == Hash then
			return (res.map {|r| r.to_s }).join("; ")
		else
			return "No results!"
		end
	rescue => e
		if e.to_s == "cannot interpret as address: No entries for Domain." then # The URL, that is given, is invalid.
			return "Invalid URL or no entries for Domain."
		elsif e.class==Dnsruby::NXDomain then
			return "No entries for Domain."
		else
			return (e.to_s or "Error unknown.")
		end
	end
end
def dnsWrapper(addresses,type="ANY")
	res = ""
	addrs = addresses.gsub(/\;+$/, '').split(";")
	addrs.each {|addr|
	addr = addr.lstrip().rstrip()
	res += dns(addr,type) + " ; "
	}
	return res.strip.chomp(";")
end
def rdnsWrapper(addresses)
	res = ""
	addrs = addresses.gsub(/\;+$/, '').split(";")
	addrs.each {|addr|
	addr = addr.lstrip().rstrip()
	res += rdns(addr) + " ; "
	}
	return res.strip.chomp(";")
end
def cmd_dnsall(args,nick,chan,rawargs="",pipeargs="")
	return dnsWrapper(args)
end
def cmd_dnsa(args,nick,chan,rawargs="",pipeargs="")
	return dnsWrapper(args,"A")
end
def cmd_dnsns(args,nick,chan,rawargs="",pipeargs="")
	return dnsWrapper(args,"NS")
end
def cmd_dnsmx(args,nick,chan,rawargs="",pipeargs="")
	return dnsWrapper(args,"MX")
end
def cmd_rdns(args,nick,chan,rawargs="",pipeargs="")
	return rdnsWrapper(args)
end
$commands["dns_all"] = :cmd_dnsall
$commands["dns_mx"] = :cmd_dnsmx
# $commands["dns_type"] = :cmd_dnst doesnt work :/
$commands["dns"] = :cmd_dnsa
$commands["dns_a"] = :cmd_dnsa
$commands["rdns"] = :cmd_rdns

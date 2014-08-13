# Perform DNS lookups
# Made by vifino
require "dnsruby"
def dns(addr,type="ANY")
	if addr.empty? then return "Can't lookup nothing!" end
	rs = Dnsruby::DNS.new
	begin
		res = rs.getresources(addr, type)
		if res!=nil then
			#return (res.map {|r| r.rdata_to_string.gsub(/[[:cntrl:]]/, '') }).join("; ")
			return (res.map {|r| r.rdata_to_string.gsub(/[[:cntrl:]]/, '') })
		else
			return ["No results!"]
		end
	rescue => e
		if e.to_s == "no implicit conversion of nil into Array" then # The URL, that is given, is invalid.
			return ["Invalid URL."]
		elsif e.class==Dnsruby::NXDomain then
			return ["No entries for Domain."]
		else
			return [(e.to_s or "Error unknown.")]
		end
	end
end
def rdns(addr)
	if addr.empty? then return ["Can't lookup nothing!"] end
	rs = Dnsruby::DNS.new
	begin
		res = rs.getnames addr
	#	if res.class == Hash then
			#return (res.map {|r| r.to_s }).join("; ")
			return (res.map {|r| r.to_s })
	#	else
	#		p (res.map {|r| r.to_s })
	#		return "No results!"
	#	end
	rescue => e
		if e.to_s == "cannot interpret as address: No entries for Domain." then # The URL, that is given, is invalid.
			return ["Invalid URL or no entries for Domain."]
		elsif e.class==Dnsruby::NXDomain then
			return ["No entries for Domain."]
		else
			return [(e.to_s or "Error unknown.")]
		end
	end
end
def dnsWrapper(addresses,type="ANY")
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
		dns(addr,type).each{|a|
			res.push a
		}
	}
	return res
end
def rdnsWrapper(addresses)
	res = []
	if addresses.class==String then
		addrs = addresses.strip.gsub(/\;+$/, '').split(";")
	elsif addresses.class==Array then
		addrs=addresses
	else
		return "Invalid type of input."
	end
	addrs.each {|addr|
		addr = addr.strip()
		p addr
		rdns(addr).each{|a|
			p a
			res.push a
		}
	}
	return res
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
addCommand("dns_all",:cmd_dnsall,"Show every DNS info of a domain.")
addCommand("dns_mx",:cmd_dnsmx,"Shows the MX record of a domain.")
# $commands["dns_type"] = :cmd_dnst doesnt work :/
addCommand("dns",:cmd_dnsa,"Shows the A Record of a domain.")
addCommand("dns_a",:cmd_dnsa,"Shows the A Record of a domain.")
addCommand("rdns",:cmd_rdns,"Lookup the domain of an IP.")

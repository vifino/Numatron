# Perform DNS lookups
# Made by vifino
require "dnsruby"
def dns(addr,type="ANY")
	if addr.empty? then return "Can't lookup nothing!" end
	rs = Dnsruby::DNS.new
	begin
		res = rs.getresources(addr, type)
		return "No results!" if (res.empty? or res==nil)
		return (res.map {|r| r.rdata_to_string.gsub(/[[:cntrl:]]/, '') }).join("; ")
	rescue => e
		return e.to_s
	end
end
def rdns(addr)
	if addr.empty? then return "Can't lookup nothing!" end
	rs = Dnsruby::DNS.new
	begin
		res = rs.getnames addr
		return "No results!" if (res.empty? or res==nil)
		return (res.map {|r| r.to_s }).join("; ")
	rescue => e
		return e.to_s
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
def cmd_rdns(args,nick,chan,rawargs="",pipeargs="")
	return rdnsWrapper(args)
end
$commands["dns_all"] = :cmd_dnsall
# $commands["dns_type"] = :cmd_dnst doesnt work :/
$commands["dns"] = :cmd_dnsa
$commands["rdns"] = :cmd_rdns

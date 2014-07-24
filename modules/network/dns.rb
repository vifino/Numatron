# Perform DNS lookups
# Made by vifino
require "dnsruby"
def dns(addr,type="ANY")
	rs = Dnsruby::DNS.new
	begin
		res = rs.getresources(addr, type)
		return "No results!" if res.empty?
		return (res.map {|r| r.rdata_to_string.gsub(/[[:cntrl:]]/, '') }).join(", ")
	rescue => e
		return e.to_s
	end
end
def rdns(addr)
	rs = Dnsruby::DNS.new
	begin
		res = rs.getnames addr
		return "No results!" if (res.empty? or res==nil)
		return (res.map {|r| r.to_s }).join(", ")
	rescue => e
		return e.to_s
	end
end
def cmd_dnsall(args,nick,chan,rawargs="",pipeargs="")
	return dns(args.split.first)
end
def cmd_dnsa(args,nick,chan,rawargs="",pipeargs="")
	return dns(args.split.first,"A")
end
def cmd_dnst(args,nick,chan,rawargs="",pipeargs="")
	return dns(args.split.last,args.split.first)
end
def cmd_rdns(args,nick,chan,rawargs="",pipeargs="")
	return rdns(args.split.first)
end
$commands["dns_all"] = :cmd_dnsall
# $commands["dns_type"] = :cmd_dnst doesnt work :/
$commands["dns"] = :cmd_dnsa
$commands["rdns"] = :cmd_rdns

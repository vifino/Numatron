# Perform DNS lookups
# Made by vifino
require "dnsruby"
def dns(args,nick="",chan="",rawargs="",pipeargs="")
	arr = args.first.split
	rs = Dnsruby::DNS.new
	begin
		res = rs.getresources(addr, "ANY")
		return "No results!" if results.empty?
		return (res.map {|r| r.rdata_to_string.gsub(/[[:cntrl:]]/, '') }).join(", ")
	rescue => e
		return e.to_s
	end
end
def rdns(args,nick="",chan="",rawargs="",pipeargs="")
	arr = args.first.split
	rs = Dnsruby::DNS.new
	begin
		res = rs.getnames addr.first
		return "No results!" if results.empty?
		return (results.map {|r| r.to_s }).join(", ")
	rescue => e
		return e.to_s
	end
end
$commands["dns"] = :dns
$commands["rdns"] = :rdns

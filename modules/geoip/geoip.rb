# Geolocate IP's using geoip databases
# Made by vifino
require 'geoip'
geoipdb = "modules/geoip/GeoIP.dat"
geocitydb = "modules/geoip/GeoLiteCity.dat"
if not (File.exists?(geoipdb) and File.exists?(geoipdb))
	puts "GeoIP Databases not found! The GeoIP Commands will not work!"
else
	@geoipdb = GeoIP.new(geoipdb)
	@geocitydb = GeoIP.new(geocitydb)
	$commands["geoip_country"] = :geoip_countryWrapper
	$commands["geoip_city"] = :geoip_cityWrapper
	$commands["geoip"] = :geoip_cityWrapper
end
def geoip_country(addr)
	if addr then
		begin
			res = @geoipdb.country(addr)
			return "Country: "+(res.country_name or "Unknown")+", '"+(res.country_code3 or "Unknown")+"'"
		rescue => exception
			return "Invalid URL or URL not found in Database!"
		end
	end
end
def geoip_city(addr)
	if addr then
		begin
			res = @geocitydb.city(addr)
			p res.city_name
			if not res.city_name =="" then
				city = res.city_name
			else
				city = "Unknown"
			end
			return city+", "+(res.country_name or "Unknown")
		rescue => exception
			return "Invalid URL or URL not found in Database!"
		end
	end
end
def geoip_countryWrapper(addresses,nick,chan,rawargs="",pipeargs="")
	res = ""
	addrs = addresses.split(",")
	addrs.each {|addr|
	addr = addr.lstrip().rstrip()
	res += geoip_country(addr)+"; "
	}
	return res
end
def geoip_cityWrapper(addresses,nick,chan,rawargs="",pipeargs="")
	res = ""
	addrs = addresses.split(",")
	addrs.each {|addr|
	addr = addr.lstrip().rstrip()
	res += geoip_city(addr)+"; "
	}
	return res
end

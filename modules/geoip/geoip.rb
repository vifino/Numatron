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
	$commands["geomaps"] = :geomapsWrapper
end
def geoip_country(addr)
	if not addr.empty? then
		begin
			res = @geoipdb.country(addr)
			return "Country: "+(res.country_name or "Unknown")+", '"+(res.country_code3 or "Unknown")+"'"
		rescue => exception
			return "Invalid URL or URL not found in Database!"
		end
	else
		return "Can't locate nothing!"
	end
end
def geoip_city(addr)
	if not addr.empty? then
		begin
			res = @geocitydb.city(addr)
			if not res.city_name =="" then
				city = res.city_name
			else
				city = "Unknown"
			end
			return city+", "+(res.country_name or "Unknown")
		rescue => exception
			return "Invalid URL or URL not found in Database!"
		end
	else
		return "Can't locate nothing!"
	end
end
def geomaps(addr)
	if not addr.empty? then
		begin
			res = @geocitydb.city(addr)
			lat = res.latitude
			long= res.longitude
			if lat and long then
				url = "http://maps.google.com/maps?z=12&t=m&q=loc:"+lat.to_s+"+"+long.to_s
				return url
			else
				return "Position data incomplete."
			end
		rescue => exception
			puts exception
			return "Invalid URL or URL not found in Database!"
		end
	else
			return "Can't locate nothing!"
	end
end
def geoip_countryWrapper(addresses,nick,chan,rawargs="",pipeargs="")
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
		res.push geoip_country(addr)
	}
	return res
end
def geoip_cityWrapper(addresses,nick,chan,rawargs="",pipeargs="")
	res = []
	if addresses.class==String then
		addrs = addresses.gsub(/\;+$/, '').split(";")
	elsif addresses.class==Array then
		addrs=addresses
	else
		return "Invalid type of input."
	end
	addrs.each {|addr|
		p addr
		addr = addr.lstrip().rstrip()
		res.push geoip_city(addr)
	}
	return res
end
def geomapsWrapper(addresses,nick,chan,rawargs="",pipeargs="")
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
		res.push geomaps(addr)
	}
	return res
end

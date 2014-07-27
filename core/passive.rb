# Passive data collection, WIP
# Made by vifino
require "json"
@passivedata = Hash.new
def passive_newacc(acc)
	if not @passivedata[acc].class == "Hash" then
		@passivedata[acc] = Hash.new
		@passivedata[acc]["addr"] = ""
		@passivedata[acc]["acc"] = ""
		@passivedata[acc]["user"] = ""
		@passivedata[acc]["real"] = ""
		@passivedata[acc]["host"] = ""
		@passivedata[acc]["chan"] = {}
	end
end
def who(chan) # Not so passive :3
	@bot.send "WHO #{chan} c%cuihsnfar"
end
def whois(user)
	@bot.send "whois #{user}"
end
def passive_process(raw)
	data= @bot.msgtype(raw)
	type = data[0]
	nick = data[1]
	chan = data[2]
	msg = data[3]
	username = data[4]
	hostname = data[5]
	if type=="msg" or type=="join" then
		begin
		if not @passivedata then @passivedata = {} end
		if not @passivedata.include? nick then @passivedata[nick] = {} end
		@passivedata[nick]["user"] = username
		@passivedata[nick]["host"] = hostname
		if not @passivedata[nick]["chan"] then @passivedata[nick]["chan"] = [] end
		if not @passivedata[nick]["chan"].include? chan then @passivedata[nick]["chan"].push chan end
		if type=="msg" then
			if not @passivedata[nick]["lines"] then @passivedata[nick]["lines"] = 1 end
			@passivedata[nick]["lines"] += 1
			if not @passivedata[nick]["words"] then @passivedata[nick]["words"] = 0 end
			@passivedata[nick]["words"] += (msg.split(" ").size) + 1
			if not @passivedata[nick]["chars"] then @passivedata[nick]["chars"] = 0 end
			@passivedata[nick]["chars"] += (msg.split("").size) + 1
		end
		rescue => e

		end
	elsif type=="notice" then
		begin
		if not @passivedata then @passivedata = {} end
		if nick == "NickServ" then
			if ret = raw.match(/:Information on (.*?) \(account (.*?)\)/) then
				puts "Nickserv account info!"
				nickn = ret[1].to_s.delete("\x02")
				acc = ret[2].to_s.delete("\x02")
				if not @passivedata.include? ret[1] then @passivedata[ret[1]] = {} end
				@passivedata[nickn]["acc"] = acc
				@authwrite.puts acc
				@authwrite.flush
			end

		end
		rescue => e

		end
	elsif match = raw.match(/^:(.*) 353 (.*?) (.*?) (.*?) :(.*)/)
		begin
		if not @passivedata then @passivedata = {} end
		chan2 = match[4]
		mode = match[3]
		names = match[5]
		names.split(" ").each {|name|
			name = name.strip.gsub("@","").gsub("+","")
			if not @passivedata.include? name then @passivedata[name] = {} end
			if not @passivedata[name]["chan"] then @passivedata[name]["chan"] = [] end
			if not @passivedata[name]["chan"].include? chan2 then @passivedata[name]["chan"].push chan2 end
		}
		rescue => e

		end
	elsif match = raw.match(/^:(.*?) 319 (.*?) (.*?) :(.*)/) then
		begin
		if not @passivedata then @passivedata = {} end
		name = match[3]
		chans = match[4]
		chans.split(" ").each {|chan2|
			chan2 = chan2.strip.gsub("@","").gsub("+","")
			if not @passivedata.include? name then @passivedata[name] = {} end
			if not @passivedata[name]["chan"] then @passivedata[name]["chan"] = [] end
			if not @passivedata[name]["chan"].include? chan2 then @passivedata[name]["chan"].push chan2 end
		}
		rescue => e

		end
	elsif match = raw.match(/^:(.*?) 311 (.*?) (.*?) (.*?) (.*?) (.*?) :(.*)/) then
		begin
		if not @passivedata then @passivedata = {} end
		name = match[3]
		user = match[4]
		addr = match[5]
		real = match[7]
		@passivedata[name]["user"] = user
		@passivedata[name]["addr"] = addr
		@passivedata[name]["real"] = real.delete("^\u{0000}-\u{007F}") # Remove unicode, because it kills .to_json
		rescue => e

		end
	elsif match = raw.match(/^:(.*) 354 (.*?) (.*?) (.*?) (.*?) (.*?) (.*?) (.*?) (.*?) (.*?) (.*?):(.*)/) then
		begin
		if not @passivedata then @passivedata = {} end
		chan = match[3]
		user = match[4]
		ip = match[5]
		host = match[6]
		server = match[7]
		nick = match[8]
		mode = match[9]
		acc = match[10]
		realname = match[12].delete("^\u{0000}-\u{007F}") # Remove unicode, because it kills .to_json
		if not @passivedata.include? nick then @passivedata[nick] = {} end
		if not @passivedata[nick]["chan"] then @passivedata[nick]["chan"] = [] end
		if not @passivedata[nick]["chan"].include? chan then @passivedata[nick]["chan"].push chan end
		@passivedata[nick]["user"] = user
		@passivedata[nick]["host"] = host
		@passivedata[nick]["server"] = server
		@passivedata[nick]["acc"] = acc
		@passivedata[nick]["ip"] = ip
		@passivedata[nick]["real"] = realname
		rescue => e

		end
	elsif type=="nick" then
		begin
		# Move table to new pos
		if not @passivedata then @passivedata = {} end
		if not @passivedata.include? nick then @passivedata[nick] = {} end
		@passivedata[chan] = @passivedata[nick]
		@passivedata[nick] = nil
		@passivedata[chan]["user"] = username
		@passivedata[chan]["host"] = hostname
		rescue => e

		end
	end
end
def passive_start
	@fifoPassive = open("pipes/passive","r+")
	#if not job_passive then
		job_passive = fork do
			until false do
				passive_process(@fifoPassive.gets)
			end
		end
	#end
end
def passive_dump
	@passivedata.to_json # In json, of course.
end

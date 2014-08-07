# Passive data collection, WIP
# Made by vifino
require "json"
@passivedata = Hash.new
@passivedata["users"] = Hash.new
@passivedata["chans"] = Hash.new
def passive_newacc(acc)
	if not @passivedata[acc].class == "Hash" then
		@passivedata["users"][acc] = Hash.new
		@passivedata["users"][acc]["addr"] = ""
		@passivedata["users"][acc]["acc"] = ""
		@passivedata["users"][acc]["user"] = ""
		@passivedata["users"][acc]["real"] = ""
		@passivedata["users"][acc]["host"] = ""
		@passivedata["users"][acc]["chan"] = {}
	end
end
def who(chan) # Not so passive :3
	@bot.send "WHO #{chan} c%cuihsnfar"
end
def whois(user)
	@bot.send "whois #{user}"
end
def getAcc(user)
	who user
	sleep (0.5)
	if not user.include? "#" then
		for i in 0..20
			if @passivedata["users"][user] then
				if acc=@passivedata["users"][user]["acc"] then
					return acc
				end
				sleep(0.2)
			end
		end
		return nil
	else
		return "Channel not a user!"
	end
end
def chanProcess(chan,nick,mode=nil)
	@passivedata["chans"]||={}
	@passivedata["chans"][chan]||={}
	@passivedata["chans"][chan]["users"]||={}
	if mode!=nil then
		@passivedata["chans"][chan]["users"][nick]=mode # Maybe copy data over?
	else
		@passivedata["chans"][chan]["users"][nick]="Unknown"
	end
	#@passivedata["chans"][chan]["users"][nick]
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
			if not @passivedata["users"] then @passivedata["users"] = {} end
			if not @passivedata["users"].include? nick then @passivedata["users"][nick] = {} end
			@passivedata["users"][nick]["user"] = username
			@passivedata["users"][nick]["host"] = hostname
			if not @passivedata["users"][nick]["chan"] then @passivedata["users"][nick]["chan"] = [] end
			if not @passivedata["users"][nick]["chan"].include? chan then @passivedata["users"][nick]["chan"].push chan end
			if type=="msg" then
				if not @passivedata["users"][nick]["lines"] then @passivedata["users"][nick]["lines"] = 1 end
				@passivedata["users"][nick]["lines"] += 1
				if not @passivedata["users"][nick]["words"] then @passivedata["users"][nick]["words"] = 0 end
				@passivedata["users"][nick]["words"] += (msg.split(" ").size) + 1
				if not @passivedata["users"][nick]["chars"] then @passivedata["users"][nick]["chars"] = 0 end
				@passivedata["users"][nick]["chars"] += (msg.split("").size) + 1
				@passivedata["users"][nick]["avgchars"] = @passivedata["users"][nick]["chars"] / @passivedata["users"][nick]["lines"]
				@passivedata["users"][nick]["avgwords"] = @passivedata["users"][nick]["words"] / @passivedata["users"][nick]["lines"]
				chanProcess(chan,nick)
			end
		rescue => e

		end
	elsif type=="notice" then
		begin
			if not @passivedata["users"] then @passivedata["users"] = {} end
			if nick == "NickServ" then
				if ret = raw.match(/:Information on (.*?) \(account (.*?)\)/) then
					puts "Nickserv account info!"
					nickn = ret[1].to_s.delete("\x02")
					acc = ret[2].to_s.delete("\x02")
					if not @passivedata["users"].include? ret[1] then @passivedata["users"][ret[1]] = {} end
					@passivedata["users"][nickn]["acc"] = acc
					#@authwrite.puts acc
					#@authwrite.flush
				else
					# Do stuff
				end
			end
		rescue => e

		end
	elsif match = raw.match(/^:(.*) 353 (.*?) (.*?) (.*?) :(.*)/)
		begin
			if not @passivedata["users"] then @passivedata["users"] = {} end
			chan2 = match[4]
			mode = match[3]
			names = match[5]
			names.split(" ").each {|name|
				name = name.strip.gsub("@","").gsub("+","")
				if not @passivedata["users"].include? name then @passivedata["users"][name] = {} end
				if not @passivedata["users"][name]["chan"] then @passivedata[name]["chan"] = [] end
				if not @passivedata["users"][name]["chan"].include? chan2 then @passivedata["users"][name]["chan"].push chan2 end
				chanProcess(chan2,name)
			}
		rescue => e

		end
	elsif match = raw.match(/^:(.*?) 319 (.*?) (.*?) :(.*)/) then
		begin
			if not @passivedata["users"] then @passivedata["users"] = {} end
			name = match[3]
			chans = match[4]
			chans.split(" ").each {|chan2|
				chan = chan2.strip.gsub("@","").gsub("+","")
				if not @passivedata["users"].include? name then @passivedata["users"][name] = {} end
				if not @passivedata["users"][name]["chan"] then @passivedata["users"][name]["chan"] = [] end
				if not @passivedata["users"][name]["chan"].include? chan then @passivedata["users"][name]["chan"].push chan end
				chanProcess(chan,name,chan2.strip.match(/^[@+~]/)[0])
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
			@passivedata["users"][name]["user"] = user
			@passivedata["users"][name]["addr"] = addr
			@passivedata["users"][name]["real"] = real.delete("^\u{0000}-\u{007F}") # Remove unicode, because it kills .to_json
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
			if not @passivedata["users"].include? nick then @passivedata["users"][nick] = {} end
			if not @passivedata["users"][nick]["chan"] then @passivedata["users"][nick]["chan"] = [] end
			if not @passivedata["users"][nick]["chan"].include? chan then @passivedata["users"][nick]["chan"].push chan end
			@passivedata["users"][nick]["user"] = user
			@passivedata["users"][nick]["host"] = host
			@passivedata["users"][nick]["server"] = server
			@passivedata["users"][nick]["acc"] = acc
			@passivedata["users"][nick]["ip"] = ip
			@passivedata["users"][nick]["real"] = realname
			chanProcess(chan,nick)
		rescue => e

		end
	elsif type=="nick" then
		puts "--- #{nick} is now known as #{chan}"
		begin
		# Move table to new pos
		if not @passivedata["users"] then @passivedata["users"] = {} end
		@passivedata["users"][chan] = (@passivedata["users"][nick] or {})
		#@passivedata.delete_at nick
		@passivedata["users"] = @passivedata["users"].reject{|k|k==nick}
		@passivedata["users"][chan]["user"] = username
		@passivedata["users"][chan]["host"] = hostname
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
if not @rawhooks.include? :passive_process then
	@rawhooks.push(:passive_process)
end

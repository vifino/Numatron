# Passive data collection, WIP
# Made by vifino
require "json"
@passivedata||= Hash.new
@passivedata["users"]||= Hash.new
@passivedata["chans"]||= Hash.new
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
def chanProcess(chan,nick,mode=nil)
	@passivedata["chans"]||={}
	@passivedata["chans"][chan]||={}
	@passivedata["chans"][chan]["users"]||={}
	if mode!=nil then
		@passivedata["chans"][chan]["users"][nick]=mode.gsub(/^[hg]/i,"") # Maybe copy data over?
		@passivedata["users"][nick]["chan"][chan]||={}
		@passivedata["users"][nick]["chan"][chan]=mode.gsub(/^[hg]/i,"")
		if mode.match(/^h/i) then
			@passivedata["users"][nick]["away"]=false
		elsif mode.match(/^g/i) then
			@passivedata["users"][nick]["away"]=true
		end
	else
		@passivedata["chans"][chan]["users"][nick]||="Unknown"
		@passivedata["users"][nick]["away"]||="Unknown"
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
			@passivedata["users"][nick]["chan"]||={}
			@passivedata["users"][nick]["chan"][chan]||=""
			if type=="msg" then
				if not @passivedata["users"][nick]["lines"] then @passivedata["users"][nick]["lines"] = 1 end
				@passivedata["users"][nick]["lines"] += 1
				if not @passivedata["users"][nick]["words"] then @passivedata["users"][nick]["words"] = 0 end
				@passivedata["users"][nick]["words"] += msg.split(" ").size
				if not @passivedata["users"][nick]["chars"] then @passivedata["users"][nick]["chars"] = 0 end
				@passivedata["users"][nick]["chars"] += msg.size
				@passivedata["users"][nick]["avgchars"] = @passivedata["users"][nick]["chars"] / @passivedata["users"][nick]["lines"]
				@passivedata["users"][nick]["avgwords"] = @passivedata["users"][nick]["words"] / @passivedata["users"][nick]["lines"]
				chanProcess(chan,nick)
			end
		rescue => e
			#puts e
		end
	elsif type=="ctcp" then
		puts "CTCP"
		#begin
			#if match=msg.strip.match(/^PING(.*)/) then
			#	puts "PING"
			#	retdata=match[1].strip
			#	puts retdata
			#	if chan==@bot.nick then chan=nick end
			#	#@bot.msg(chan,"\x01PONG #{retdata}\x01")
			#	ret=nil
			#	tme=retdata.split(" ").first.to_i
			#	if not tme==0 then
			#		ret=(Time.now.to_i-tme).to_s
			#	else
			#		ret=retdata
			#	end
			#	@bot.notice(chan,"\x01PING #{ret}\x01")
			#end
		#rescue => e
		#	puts e
		#end
	elsif type=="notice" then
		begin
			puts "--- #{nick} -> #{chan}: #{msg}"
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
			#puts e
		end
	elsif match = raw.match(/^:(.*) 353 (.*?) (.*?) (.*?) :(.*)/) # NAMES
		begin
			#puts "NAMES"
			if not @passivedata["users"] then @passivedata["users"] = {} end
			chan2 = match[4]
			mode = match[3]
			names = match[5]
			names.split(" ").each {|name2|
				name = name2.strip.gsub("@","").gsub("+","")
				#puts name
				@passivedata["users"][name]||= {}
				@passivedata["users"][name]["chan"] ||= {}
				if not @passivedata["users"][name]["chan"][chan2] then @passivedata["users"][name]["chan"][chan2]="" end
				match=name2.strip.match(/[@\+\~]/)
				if match then
					chanProcess(chan2,name,match[0])
				else
					chanProcess(chan2,name,"")
				end
			}
		rescue => e
			p e
		end
	elsif match = raw.match(/^:(.*?) 319 (.*?) (.*?) :(.*)/) then
		begin
			if not @passivedata["users"] then @passivedata["users"] = {} end
			name = match[3]
			chans = match[4]
			chans.split(" ").each {|chan|
				chan2 = chan.strip.gsub("@","").gsub("+","")
				if not @passivedata["users"].include? name then @passivedata["users"][name] = {} end
				if not @passivedata["users"][name]["chan"] then @passivedata["users"][name]["chan"] = [] end
				if not @passivedata["users"][name]["chan"][chan2] then @passivedata["users"][name]["chan"][chan2]="" end
				puts chan
				match=chan.strip.match(/[@\+\~]/)
				if match then
					chanProcess(chan2,name,match[0])
				else
					chanProcess(chan2,name,"")
				end
			}
		rescue => e
			#puts e
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
			#puts e
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
			if not @passivedata["users"][nick]["chan"] then @passivedata["users"][nick]["chan"] = {} end
			if not @passivedata["users"][nick]["chan"][chan] then @passivedata["users"][nick]["chan"][chan]="" end
			@passivedata["users"][nick]["user"] = user
			@passivedata["users"][nick]["host"] = host
			@passivedata["users"][nick]["server"] = server
			@passivedata["users"][nick]["acc"] = acc
			@passivedata["users"][nick]["ip"] = ip
			@passivedata["users"][nick]["real"] = realname
			chanProcess(chan,nick,mode)
		rescue => e
			#puts e
		end
	elsif type=="nick" then
		puts "--- #{nick} is now known as #{chan}"
		begin
			# Move table to new pos
			if not @passivedata["users"] then @passivedata["users"] = {} end
			@passivedata["users"][chan] = (@passivedata["users"][nick] or {})
			#@passivedata.delete_at nick
			@passivedata["users"] = @passivedata["users"].reject{|k|k==nick}
			@passivedata["chans"].each{|c|
				@passivedata["chans"][c]=@passivedata["chans"][c].reject{|k|k==nick}
			}
			@passivedata["users"][chan]["user"] = username
			@passivedata["users"][chan]["host"] = hostname
		rescue => e

		end
	elsif type=="part" then
		@passivedata["users"] = @passivedata["users"] or {}
		@passivedata["users"][nick] = (@passivedata["users"][nick] or {})
		@passivedata["users"][nick]["chan"] = @passivedata["users"][nick]["chan"] or {}
		@passivedata["chans"][chan]=@passivedata["chans"][chan] or {}
		@passivedata["chans"][chan]["users"]||={}
		if @passivedata["users"][nick]["chan"][chan] then @passivedata["users"][nick]["chan"].delete(chan) end
		if @passivedata["chans"][chan]["users"][nick] then @passivedata["chans"][chan]["users"].delete(nick) end
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

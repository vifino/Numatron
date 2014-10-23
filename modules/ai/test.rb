# Example: Showing how to add hooks to raw data.
# Made by vifino
String.class_eval do
		def isGreeting?
			str=self.to_s.downcase
			case
				when str.include?("hello")
					true
				when str.include?("hey")
					true
				when str.include?("hai")
					true
				when str.include?("hi")
					true
				when str.include?("oi")
					true
				when str.include?("oy")
					true
				when str.include?("yo")
					true
			else
				false
			end
		end
end
def testai(raw)# this isnt even an ai q_q
	data= @bot.msgtype(raw)
	type = data[0]
	nick = data[1]
	chan = data[2]
	msg = data[3]
	username = data[4]
	hostname = data[5]
	if type =="msg" and (!isBlacklisted? nick) then
		msg = msg.downcase
		if (msg.isGreeting?) and (msg.include? @bot.nick.downcase) then
			@bot.msg(chan,"Hello #{nick}!")
		elsif msg.downcase.include? "cafebabe" then
			@bot.msg(chan,"Mmmmhh...")
		elsif msg.downcase.include? "skynet" then
			@bot.msg(chan,"D:")
			@bot.action(chan,"hides")
		end
	end
end
#if not @rawhooks.include? :testai then
#	@rawhooks.push :testai
#end

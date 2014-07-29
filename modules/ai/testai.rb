# Example: Showing how to add hooks to raw data.
# Made by vifino
def testai(raw)
	data= @bot.msgtype(raw)
	type = data[0]
	nick = data[1]
	chan = data[2]
	msg = data[3]
	username = data[4]
	hostname = data[5]
	if type =="msg" then
		if msg.downcase.include? "hello" and msg.downcase.include? @bot.nick then
			@bot.msg(chan,"Hello #{nick}!")
		end
	end
end
@rawhooks.push :testai

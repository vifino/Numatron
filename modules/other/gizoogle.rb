# Use gizoogle textilizer as as any other command
# Made by vifino
def gizoogle(text="",nick="",chan="",rawargs="",pipeargs="")
	uri = URI.parse("http://www.gizoogle.net/textilizer.php")
	http = Net::HTTP.new(uri.host, uri.port)
	begin
		request = Net::HTTP::Post.new(uri.request_uri)
		request.body="translatetext="+text.to_s
		response = http.request(request)
		return response.body.match("<textarea type=\"text\" name=\"translatetext\" style=\"width: 600px; height:250px;\"/>(.*?)</textarea>")[1]
	rescue => e
		puts e
	end
end
addCommand("gizoogle",:gizoogle,"Gangsta-ify input, yo!")

# Use http://whatthecommit.com/ for random commit messages.
# Made by vifino
def whatthecommit(text="",nick="",chan="",rawargs="",pipeargs="")
	uri = URI.parse("http://whatthecommit.com/")
	http = Net::HTTP.new(uri.host, uri.port)
	begin
		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		puts response.body
		return response.body.match(/<p>(.*)\n<\/p>/)[1]
	rescue => e
		puts e
	end
end
addCommand("commitmessage",:whatthecommit,"[insert explanation for random commit message generator here]")

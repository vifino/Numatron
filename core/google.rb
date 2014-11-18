# Google api ( WIP )
# Made by vifino
require "json"

class Google
	def image(term,item=1)
		JSON.parse(open('https://ajax.googleapis.com/ajax/services/search/images?v=1.0&start=0&q='+CGI.escape(term)).read)['responseData']['results'][item]['tbUrl']
	end
end

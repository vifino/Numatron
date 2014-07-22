# Basic hastebin interaction
# Made by vifino
require "net/http"
require 'json'
require 'faraday'
def putHB(code)
	if code then
		uri = URI.parse("http://hastebin.com/documents")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri)
		request.body=code
		response = http.request(request)
		data = JSON.parse(response.body)
		puts data['key']
		if data["key"] then
			return "http://hastebin.com/raw/"+data['key']
		else
			return "Error getting data!"
		end
	else
		return "No content given."
	end
end
def getHB(id)
	if id.empty? then
		if id.is_valid_url? then
			url = id
		else
			if id.length == 10 then
				url = "http://hastebin.com/raw/"+id
				return "URL or Hastebin ID is wrong."
			end
		end
		uri = URI.parse(url)
		#Net::HTTP.get_print(uri)
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.request(Net::HTTP::Get.new(uri.request_uri))
		begin
			if dat=JSON.parse(response.body) then
				if dat["message"] then
					return "Document not found"
				end
			end
		rescue => e
			begin
				http = Net::HTTP.new(uri.host, uri.port)
				response = http.request(Net::HTTP::Get.new(uri.request_uri))
				return response.body
			rescue => e2
				return e2
			end
		end
		return data
	end
	return "Can't get nothing!"
end

def gethb_cmd(args,nick,channel,rawargs="",pipeargs="") # php
	getHB args
end
def puthb_cmd(args,nick,channel,rawargs="",pipeargs="") # php
	putHB args
end
$commands["get"] = :gethb_cmd
$commands["put"] = :puthb_cmd
$commands["gethb"] = :gethb_cmd
$commands["puthb"] = :puthb_cmd

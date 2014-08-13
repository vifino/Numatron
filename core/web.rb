# Basic hastebin interaction
# Made by vifino
require "net/http"
require 'json'
def putHB(code="")
	if not code.empty? then
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

def get(id="")
	if not id.empty? then
		url2 = "http://"+(id.gsub(/http:\/\//,""))
		puts url2
		if url2.is_valid_url? then
			url = url2
		elsif id.length == 10 then
			url2 = "http://"+(id.delete("http://"))
			if url2.is_valid_url? then
				url = url2
			else
				url = "http://hastebin.com/raw/"+id
			end
		else
			return "Hastebin ID is wrong."
		end
		uri = URI.parse(url)
		#Net::HTTP.get_print(uri)
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.request(Net::HTTP::Get.new(uri.request_uri))
		begin
			if dat=JSON.parse(response.body) then
				if dat["message"] then
					return dat["message"]
				end
			end
		rescue => e
			begin
				http = Net::HTTP.new(uri.host, uri.port)
				response = http.request(Net::HTTP::Get.new(uri.request_uri))
				if response.body then
					return response.body
				end
				return "No Content."
			rescue => e2
				return e2.to_s
			end
		end
		return data
	end
	return "Can't get nothing!"
end

def getHB(id="")
	if not id.empty? then
		if id.length == 10 then
			url = "http://hastebin.com/raw/"+id
		else
			return "Hastebin ID is wrong."
		end
		uri = URI.parse(url)
		#Net::HTTP.get_print(uri)
		http = Net::HTTP.new(uri.host, uri.port)
		response = http.request(Net::HTTP::Get.new(uri.request_uri))
		begin
			if dat=JSON.parse(response.body) then
				if dat["message"] then
					return dat["message"]
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
	getHB args.to_s
end
def puthb_cmd(args,nick,channel,rawargs="",pipeargs="") # php
	putHB args.to_s
end
addCommand("get",:gethb_cmd,"Get the hastebin with the id, specified in the input.")
addCommand("put",:puthb_cmd,"Puts the input in a hastebin, and returns the url.")
addCommand("gethb",:gethb_cmd,"Get the hastebin with the id, specified in the input.")
addCommand("puthb",:puthb_cmd,"Puts the input in a hastebin, and returns the url.")

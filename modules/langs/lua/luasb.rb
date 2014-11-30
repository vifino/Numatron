# LuaSB
# Made by Sorroko and vifino
require 'rufus-lua'
def luasb_reset(args="",nick="",chan="",rawargs="",pipeargs="")
	@output = ""
	@luasb = Rufus::Lua::State.new
	#@luasb.eval(
	#	"(function() local e = error;" +
	#	"debug.sethook(function() e(\"Quota exceeded\", 3) end, \"\", 500000) " +
	#	"io = nil;  os = nil; require = nil; module = nil; dofile = nil; loadfile = nil; package = nil; debug = nil; " +
	#	"end)()")
	@luasb.eval '
do
	function maxval(tbl)
		local mx=0
		for k,v in pairs(tbl) do
			if type(k)=="number" then
				mx=math.max(k,mx)
			end
		end
		return mx
	end
	local sbox,usr,out
	local function rst()
		local tsbox={}
		sbox={
			_VERSION=_VERSION.." Sandbox",
			assert=assert,
			error=error,
			getfenv=function(func)
				if tsbox[func] then
					return false,"Nope."
				end
				local res=getfenv(func)
				if res==_G then
					return sbox
				end
				return res
			end,
			getmetatable=getmetatable,
			ipairs=ipairs,
			loadstring=function(txt,name)
				if txt:sub(1,1)=="\27" then
					return false,"Nope."
				end
				local func,err=loadstring(txt,name)
				if func then
					setfenv(func,sbox)
				end
				return func,err
			end,
			next=next,
			pairs=pairs,
			print=function(...)
				local newt = {}
				for k,v in pairs({...}) do
					newt[k] = tostring(v)
				end
				out=out ..tostring(table.concat(newt," ")).."\n"
			end,
			select=select,
			setfenv=function(func,env)
				if tsbox[func] then
					return false,no()
				end
				return setfenv(func,env)
			end,
			tonumber=tonumber,
			tostring=tostring,
			type=type,
			xpcall=xpcall,
			setmetatable=setmetatable,
			unpack = function(t)
				return unpack(t)
			end,
			rawget = rawget,
			rawset = rawset,
			rawequal = rawequal,
			os={
				clock=os.clock,
				date=os.date,
				difftime=os.difftime,
				exit=function()
					error()
				end,
				time=os.time,
			},
			io={
				write=function(...)
					out=out..table.concat({...})
				end,
			},
			coroutine=coroutine,
			channel = "",
			nick = "",
			pcall = pcall,
			username = username,
			string=string,
		}
		for k,v in pairs({
			math=math,
			table=table
		}) do
			sbox[k]={}
			for n,l in pairs(v) do
				sbox[k][n]=l
			end
		end
		for k,v in pairs(sbox) do
			if type(v)=="table" then
				for n,l in pairs(v) do
					if type(v)=="function" then
						tsbox[l]=true
					end
				end
			elseif type(v)=="function" then
				tsbox[v]=true
			end
		end
		sbox._G=sbox
	end
	rst()
	lua=function(ths,txt)
		out=""
		sbox["this"]=ths
		sbox["nick"]=nick
		sbox["channel"]=channel
		local func,err=loadstring("return "..txt,"=lua")
		if not func then
			func,err=loadstring(txt,"=lua")
			if not func then
				return err:gsub("^[\r\n]+",""):gsub("[\r\n]+$",""):gsub("[\r\n]+"," | "):sub(1,440)
			end
		end
		local func=coroutine.create(setfenv(func,sbox))
		debug.sethook(func,function()
			debug.sethook(func)
			debug.sethook(func,function()
				error("Error: Took too long.",0)
			end,"",1)
			error("Error: Took too long.",0)
		end,"",20000)
		local res={coroutine.resume(func)}
		local o
		for l1=2,maxval(res) do
			o=(o or "")..tostring(res[l1]).."\n"
		end
		return (out..(o or "nil")):gsub("^[\r\n]+",""):gsub("[\r\n]+^",""):gsub("[\r\n]+$",""):gsub("[\r\n]+"," | ")
	end
end
'
	@luasb[:to_ruby] = false
	return "Sandbox Reset!"
end
luasb_reset
def luasb(args, nick, chan,rawargs="",pipeargs)
	if args != nil then
		returnval=""
		begin
			@luasb["code"]=rawargs.to_s
			@luasb["channel"]=chan
			@luasb["nick"]=nick
			@luasb.eval('ths=nil')
			if !pipeargs.to_s.empty? then
				@luasb["ths"]=pipeargs.to_s
				if rawargs.to_s.empty? then
					@luasb["code"]=pipeargs.to_s
				end
			end
			Timeout::timeout(0.5) do
				returnval = @luasb.eval("return (lua(ths,code))")
			end
		rescue => detail
				return "Error: Took too long."
				#begin
				#returnval = @luasb.eval("return lua('return ('..code..')")
				#rescue => detail2
				#end
				#return detail.to_s
		end
					#$bot.irc.msg(chan, detail.message())
		if returnval != nil and returnval !="" then #or not @output.empty? then
			#if returnval != nil and returnval!= "" then
				#if returnval.class == "Array" then
				#	return "[table]"
				#end
				return returnval
			#end
			#if not @output.empty? then
			#	$bot.irc.msg(chan, "> " + @output)
			#end
			#elsif error
			#@bot.msg(chan,error)
		#end
		#@output = ""
		end
	end
end
addCommand("lua",:luasb,"Run Lua code in a Sandbox.")
addCommand("resetlua",:luasb_reset,"Resets the Lua Sandbox.")

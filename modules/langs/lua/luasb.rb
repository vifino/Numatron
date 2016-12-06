# LuaSB
# Made by Sorroko and vifino
# Exploited by bauen1

if !defined? JRuby
	require 'ruby-lua'
	def luasb_reset(args="",nick="",chan="",rawargs="",pipeargs="")
		@output = ""
		@luasb = Language::Lua.new()
		#@luasb.eval(
		#	"(function() local e = error;" +
		#	"debug.sethook(function() e(\"Quota exceeded\", 3) end, \"\", 500000) " +
		#	"io = nil;  os = nil; require = nil; module = nil; dofile = nil; loadfile = nil; package = nil; debug = nil; " +
		#	"end)()")

		lua_is_51 = @luasb.var("_VERSION") == "Lua 5.1"
		if lua_is_51
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
					return false,"Nope."
				end
				return setfenv(func,env)
			end,
			tonumber=tonumber,
			tostring=tostring,
			type=type,
			xpcall=xpcall,
			setmetatable=function(i, x)
				if i == sbox or i == _G then
					error("Not allowed.")
				end
				setmetatable(i, x)
			end,
			unpack = unpack,
			unicode = unicode,
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
		})
		do
			sbox[k]={}
			for n,l in pairs(v) do
				sbox[k][n]=l
			end
		end
		sbox["math"]["round"] = (function(num, idp)
			local mult = 10^(idp or 0)
			return math.floor(num * mult + 0.5) / mult
		end)
		sbox["math"]["signum"] = (function(f)
			return f == 0 and 1 or f/math.abs(f)
		end)
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
		else
			@luasb.eval '
do
	local sbox,usr,out
	local function rst()
		local tsbox={}
		sbox={
			_VERSION=_VERSION.." Sandbox",
			assert=assert,
			error=error,
			collectgarbage=function(op,arg)
				if op == "count" then
					return collectgarbage ("count")
				elseif op == "collect" or op == "" or op == nil then
					return collectgarbage ("collect")
				elseif op == "isrunning" then
					return collectgarbage ("isrunning")
				end
			end,
			dofile=function(name)
				error ("Nope.")
			end,
			ipairs=ipairs,
			load=function(ld,source,mode,env)
				return load(ld,source,"t",env or sbox)
			end,
			next=next,
			pairs=pairs,
			pcall=pcall,
			print=function(...)
				local newt = table.pack(...)
				for i=1,newt.n do
					newt[i] = tostring(newt[i])
				end
				out=out ..tostring(table.concat(newt," ")).."\n"
			end,
			rawequal=rawequal,
			rawget=rawget,
			rawlen=rawlen,
			rawset=rawset,
			select=select,
			tonumber=tonumber,
			tostring=tostring,
			type=type,
			xpcall=xpcall,
			getmetatable=function(x)
				if not (type(x) == "string") then
					return getmetatable(x)
				else
					error("Not allowed.")
				end
			end,
			setmetatable=function(i, x)
				if i == sbox or i == _ENV then
					error("Not allowed.")
				end
				assert (not rawget (x, "__gc"), "__gc method not allowed.")
				return setmetatable(i, x)
			end,
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
				type=function(obj)
					return io.type (obj)
				end,
			},
			debug={
				traceback=function(thread,message,level)
					return debug.traceback(message, 2+level)
				end,
			},
			channel = "",
			nick = "",
			username = username,
		}
		for k,v in pairs({
			math=math,
			table=table,
			bit32=bit32,
			coroutine=coroutine,
			string=string,
			utf8=utf8
		})
		do
			sbox[k]={}
			for n,l in pairs(v) do
				sbox[k][n]=l
			end
		end
		sbox["math"]["round"] = (function(num, idp)
			local mult = 10^(idp or 0)
			return math.floor(num * mult + 0.5) / mult
		end)
		sbox["math"]["signum"] = (function(f)
			return f == 0 and 1 or f/math.abs(f)
		end)
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
		sbox._ENV=sbox
	end
	rst()
	local function sanitizer (msg)
		return msg:gsub("^[\r\n]+",""):gsub("[\r\n]+$",""):gsub("[\r\n]+"," | ")
	end
	lua=function(ths,txt)
		out=""
		sbox["this"]=ths
		sbox["nick"]=nick
		sbox["channel"]=channel
		local func,err=load("return "..txt, "lua", "t", sbox)
		if not func then
			func,err=load(txt, "lua", "t", sbox)
			if not func then
				return sanitizer(err):sub(1,440)
			end
		end
		local func=coroutine.create(func)
		debug.sethook(func,function()
			debug.sethook(func)
			debug.sethook(func,function()
				error("Error: Took too long.",0)
			end,"",1)
			error("Error: Took too long.",0)
		end,"",20000)
		local res=table.pack(coroutine.resume(func))
		local o
		for l1=2,res.n do
			o=(o or "")..tostring(res[l1]).."\n"
		end
		return sanitizer (out..(o or "nil"))
	end
end
'
		end
		return "Sandbox Reset!"
	end
	luasb_reset
	def luasb(args, nick, chan,rawargs="",pipeargs)
		if args != nil then
			returnval=""
			begin
				@luasb.var("channel", chan)
				@luasb.var("nick", nick)
				ths=pipeargs.to_s
				code=if rawargs.to_s.empty? then
								ths
							else
								rawargs.to_s
							end

				Timeout::timeout(0.5) do
					#returnval = @luasb.eval("return (lua(ths,code))")
					returnval = @luasb.call("lua", ths, code)
				end
			rescue => e
				puts e.to_s
				return "Error: Took too long."
			end
			if returnval != nil and returnval !="" then #or not @output.empty? then
					return returnval
			end
		end
	end
	addCommand("lua", :luasb, "Run Lua code in a Sandbox.", true)
	addCommand(@luasb.var("_VERSION").to_s().downcase().delete(' ') ,:luasb,"Run Lua code in a Sandbox.", true)
	addCommand("resetlua", :luasb_reset, "Resets the Lua Sandbox.")
	addCommand("reset"+@luasb.var("_VERSION").to_s().downcase().delete(' '), :luasb_reset, "Resets the Lua Sandbox.")
end

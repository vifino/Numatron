# Run shell code, using docker.
# Code will be run in multiple environments. Small, rather fast.
# 64 bit only.
# Made by vifino

def tinycore(code, user="root",extradockeroptions="")
	header = ""
	if not user=="root" then
		header += "echo \"\"|adduser #{user.downcase} > /dev/null ; "
	end
	header += "cat > code ; "
	header += "exec sudo -u #{user.downcase} sh code ; "
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	`touch /tmp/tinycore_#{rnd}`
	f=File.open "/tmp/tinycore_#{rnd}","w"
	f.write code
	f.close
	o=`cat /tmp/tinycore_#{rnd}| docker run #{extradockeroptions} --rm -i zoobab/tinycore-x64 /bin/sh -c #{header.inspect} 2>&1`
	`rm /tmp/tinycore_#{rnd}`
	return o
end

def tinycoresb(code, user="skiddie")
	header = ""
	["/bin/mount", "/bin/dd", "/bin/vi","/bin/dmesg"].each { |file|
		header +="/bin/rm #{file} ; "
	}
	user = "skiddie" if user=="root"
	header += "echo \"\"|adduser #{user.downcase} > /dev/null ; "
	header += "cat > code ; "
	header += "chmod 0522 /dev/random /dev/urandom ; "
	#header += "ifconfig eth0 down ; rm /sbin/ifconfig"
	#header += "sudo -u skiddie /bin/sh -c 'timeout -t 1 ' ; "
	#header += "timeout -t 10 sh -c \'" + code.gsub(/'/,'\\\'').gsub(/\\/,'\\\\') + "\' ; "
	#header += "timeout -t 2 \'cat > file ; sh file\' ; "
	#header += "timeout -t 1 /bin/sh code ; "
	header += "exec timeout -t 1 sudo -u #{user.downcase} sh -c 'sh < /code' ; "
	#header += "exit ; "
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	`touch /tmp/tinycore_#{rnd}`
	f=File.open "/tmp/tinycore_#{rnd}","w"
	f.write code
	f.close
	o=`cat /tmp/tinycore_#{rnd}| docker run --net="none" --rm -i zoobab/tinycore-x64 /bin/sh -c #{header.inspect} 2>&1`
	`rm /tmp/tinycore_#{rnd}`
	return o.strip
end

def tinycore_command(args="",nick="",chan="",rawargs="",pipeargs="")
	pipeargs||=""
	if !rawargs.empty? then
		nick = "skiddie" if nick=="root"
		if pipeargs=="" then
			return tinycoresb(rawargs, nick.gsub(/[^0-9a-z]/i, ''))
		else
			code = "echo #{pipeargs.inspect} | #{rawargs}"
			puts code
			return tinycoresb(code,nick.gsub(/[^0-9a-z]/i, ''))
		end
	end
end

def arch(code, user="root",extradockeroptions="")
	header = ""
	if not user=="root" then
		header += "echo \"\"|adduser #{user.downcase} > /dev/null ; "
	end
	header += "cat > code ; "
	header += "exec sudo -u #{user.downcase} bash code ; "
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	`touch /tmp/arch_#{rnd}`
	f=File.open "/tmp/arch_#{rnd}","w"
	f.write code
	f.close
	o=`cat /tmp/arch_#{rnd}| docker run #{extradockeroptions} --rm -i dock0/arch /bin/sh -c #{header.inspect} 2>&1`
	`rm /tmp/arch_#{rnd}`
	return o
end

def archsb(code, user="skiddie")
	header = ""
	user = "skiddie" if user=="root"
	header += "useradd #{user.downcase} -d / ; "
	header += "cat > code ; "
	header += "chmod 0522 /dev/random /dev/urandom ; "
	header += "exec timeout 1s su - #{user.downcase} -c 'exec bash < /code' ; "
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	`touch /tmp/arch_#{rnd}`
	f=File.open "/tmp/arch_#{rnd}","w"
	f.write code
	f.close
	o=`cat /tmp/arch_#{rnd}| docker run --net="none" --rm -i dock0/arch /bin/sh -c #{header.inspect} 2>&1`
	`rm /tmp/arch_#{rnd}`
	return o.strip
end

def arch_command(args="",nick="",chan="",rawargs="",pipeargs="")
	pipeargs||=""
	if !rawargs.empty? then
		nick = "skiddie" if nick=="root"
		if pipeargs=="" then
			return archsb(rawargs, nick.gsub(/[^0-9a-z]/i, ''))
		else
			code = "echo #{pipeargs.inspect} | #{rawargs}"
			puts code
			return archsb(code,nick.gsub(/[^0-9a-z]/i, ''))
		end
	end
end


if not `which docker`.strip.chomp == "" then
	addCommand("tinycore",:tinycore_command, "Run shell code in a Tinycore VM.")
	addCommand("arch",:arch_command, "Run shell code in an Arch Linux VM")
	addCommand("vm",:tinycore_command, "Run shell code in a Tinycore VM.")
end

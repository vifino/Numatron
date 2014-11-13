# Run shell code, using docker.
# Code will be run in a tinycore environment. Small, rather fast.
# 64 bit only.
# Made by vifino

def tinycore(code)
	header = ""
	["/bin/mount", "/bin/dd", "/bin/ping", "/bin/ping6", "/bin/vi","/bin/dmesg", "/usr/bin/wget"].each { |file|
		header +="/bin/rm #{file} ; "
	}
	header += "echo \"\"|adduser skiddie > /dev/null ; "
	header += "cat > code ; "
	#header += "ifconfig eth0 down ; rm /sbin/ifconfig"
	#header += "sudo -u skiddie /bin/sh -c 'timeout -t 1 ' ; "
	#header += "timeout -t 10 sh -c \'" + code.gsub(/'/,'\\\'').gsub(/\\/,'\\\\') + "\' ; "
	#header += "timeout -t 2 \'cat > file ; sh file\' ; "
	#header += "timeout -t 1 /bin/sh code ; "
	header += 'exec timeout -t 1 sudo -u skiddie sh code ; '
	#header += "exit ; "
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	`touch /tmp/tinycore_#{rnd}`
	f=File.open "/tmp/tinycore_#{rnd}","w"
	f.write code
	f.close
	o=`cat /tmp/tinycore_#{rnd}| docker run --rm -i zoobab/tinycore-x64 /bin/sh -c #{header.inspect} 2>&1`
	`rm /tmp/tinycore_#{rnd}`
	return o
end

if not `which docker`.strip.chomp == "" then
	addCommand("tinycore",->(args,nick="",chan="",rawargs="",pipeargs="") {
		tinycore(args) if !args.empty?
	}, "Run shell code in a Tinycore VM.")
end

# Run shell code, using docker.
# Code will be run in a tinycore environment. Small, rather fast.
# You might have to add 'cgroup_enable=memory swapaccount=1' to your GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub
# 64 bit only.
# Made by vifino

def tinycore(code)
	header = ""
	["/bin/mount", "/bin/dd", "/bin/ping", "/bin/ping6", "/bin/vi","/bin/dmesg"].each { |file|
		header +="/bin/rm #{file} ; "
	}
	header += "echo \"\"|adduser eval > /dev/null ; "
	header += "sudo -u eval /bin/sh ; "
	#header += "timeout -t 10 sh -c \'" + code.gsub(/'/,'\\\'').gsub(/\\/,'\\\\') + "\' ; "
	header += "timeout -t 2 sh -c \'cat > file ; sh file\' ; " 
	header += "exit ; "
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
	
end

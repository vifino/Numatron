# Coffeescript wrapper, requires coffeescript to be installed.
# Install it with npm: [sudo] npm install -g coffee-script
# Made by vifino
def coffee2js(code)
	rnd= ('a'..'z').to_a.shuffle[0,8].join
	#`rm /tmp/coffee_#{rnd}`
	`touch /tmp/coffee_#{rnd}`
	f=File.open "/tmp/coffee_#{rnd}","w"
	f.write code
	f.close
	`cat /tmp/coffee_#{rnd}|coffee -sc` # "Compiled" coffee to js will be the output.
end
if not `which coffee`.strip.chomp.match("coffee not found") then
	$commands["coffeecompiler"]=->(args,nick="",chan="",rawargs="",pipeargs=""){
		coffee2js(args.to_s.strip)
	}
	$commands["coffeescript"]=->(args,nick="",chan="",rawargs="",pipeargs=""){
		js(coffee2js(args.to_s.strip))
	}
	$commands["c[_]"]=$commands["coffeescript"] # Shhh! Dont tell anyone!
end

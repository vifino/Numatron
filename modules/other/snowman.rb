# Do you want to build a snowman? 
# Made by vifino
def doyouwanttobuild(args,nick,chan,rawargs="",pipeargs="")
	possiblethings = ["Snowman","Meth Lab", "Gun Shop","Bomb","Hackerspace","Airplane","Paper plane","House","Supermarket","Death trap","Rocket","nuclear Rocket","Submarine","Tree House","Spaceship","Spaceshuttle","IRC network","Website Scraper","Bar","Sportsbar","Radio Station","World Destroyer","Music Shop","<Something that you want to build>"]
	"Do you want to build a "+possiblethings.sample+"?"
end
addCommand("frozen",:doyouwanttobuild,"Do you want to build a Snowman?")

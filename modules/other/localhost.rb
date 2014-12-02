# Localhost. Yes.
# Made by vifino

def getLocalhosted()
	["127.0.0.1","2130706433","go.back.to.the.kitchen","what.we.have.a.kitchen","what.the.fuck.is.a.kitchen","oops.i.burned.down.the.kitchen","please.stop.with.the.kitchen"].sample
end
addCommand("localhost",->(args="",nick="",chan="",rawargs="",pipeargs=""){
	getLocalhosted # m8!
},"Get localhosted, m8!")

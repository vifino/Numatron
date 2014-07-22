# Eval.in module
# Made by vifino
@evalin = EvalIn.new()
def evalin_rb(args,nick,channel,rawargs="",pipeargs="")
	@evalin.eval("ruby/mri-2.1",args)
end
$commands["evalrb"] = :evalin_rb

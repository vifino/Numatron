# Eval.in module
# Made by vifino
@evalin = EvalIn.new()
def evalin_rb(args,nick,channel,rawargs="",pipeargs="") # Ruby
	@evalin.eval("ruby/mri-2.1",args)
end
$commands["evalrb"] = :evalin_rb
$commands["rb"] = :evalin_rb
def evalin_py3(args,nick,channel,rawargs="",pipeargs="") # python3
	@evalin.eval("python/cpython-3.4.1",args)
end
$commands["evalpy3"] = :evalin_py3
$commands["evalpy"] = :evalin_py3
$commands["py3"] = :evalin_py3
$commands["py"] = :evalin_py3
def evalin_py2(args,nick,channel,rawargs="",pipeargs="") # python2
	@evalin.eval("python/cpython-2.7.8",args)
end
$commands["evalpy2"] = :evalin_py2
$commands["py2"] = :evalin_py2
def evalin_php(args,nick,channel,rawargs="",pipeargs="") # php
	@evalin.eval("php/php-5.5.14",args)
end
$commands["evalphp"] = :evalin_php
$commands["php"] = :evalin_php

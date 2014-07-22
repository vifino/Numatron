Numatron
========

An IRC Bot made in ruby, very WIP.
It has good piping and extensive Module support, that support multiple directories.

To make a module, make a file in `modules/`, and if you like, in subdirectories too, such as `mymodule.rb` and put something like that in it:
```
def myfunc(args,nick,channel,rawargs="",pipeargs="")
	return "Hello World! :D"
end
$commands["myfunc"] = :myfunc
```
Thats a very basic module, of course you can make things more complicated than that.

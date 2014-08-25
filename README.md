Numatron
========

An IRC Bot made in ruby, very WIP.
It has good piping and extensive Module support, that support multiple directories.

To make a module, make a file in `modules/`, and if you like, in subdirectories too, such as `mymodule.rb` and put something like that in it:
```
def myfunc(args,nick,channel,rawargs="",pipeargs="")
	return "Hello World! :D"
end
addCommand("myfunc",:myfunc,"Help for my command! :D ")
```
Thats a very basic module, of course you can make things more complicated than that.
But your plain "Hello World" can be made quicker.
```
addCommand("hello","Hello World!")
```
That's it!
There is also the way to use lambdas instead of symbols, if you prefer them, use them!

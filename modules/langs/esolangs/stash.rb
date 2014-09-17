# Stash ( name wip ) is a wip stack based language.
class	Stash
	def initialize(stack=[])
		@stack=stack
	end
	def pop
		@stack.pop.to_i
	end
	def push(a)
		@stack.push a
	end
	def eval(insts="")
		out=[]
		chrbuf=""
		insts.split(" ").each{|i|
			case
			when i=='POP'
				pop
			when i=='+'
				push pop+pop
			when '-'
				a=pop
				b=pop
				push b-a
			when i=='/'
				a=pop
				b=pop
				push b/a
			when i=='*'
				push pop*pop
			when i=='^'
				a=pop
				b=pop
				push b**a
			when i=='CLRBUF'
				chrbuf+=pop.chr
			when i=='CHRBUF'
				chrbuf+=pop.chr
			when i=='BUF'
				chrbuf+=pop.to_s
			when i=='PRINT'
				out.push pop
			when i=='PRNTBUF'
				out.push chrbuf
			when i.to_i.to_s==i # number
				push i.to_i
			end
		}
		if out.empty?
			out.push @stack[@stack.length] if @stack[@stack.length]
		end
		return out,@stack
	end
end
@stash=Stash.new

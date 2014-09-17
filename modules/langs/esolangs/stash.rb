# Stash ( name wip ) is a wip stack based language, which borrows much from Forth.
class	Stash
	def initialize(stack=[])
		@stack=stack
	end
	def sof
		raise("Stack underflow")
	end
	def pop
		@stack.pop||sof
	end
	def push(a)
		@stack<<a
	end
	def eval(insts="")
		skip=false
		out=[]
		chrbuf=""
		insts.split(" ").each{|i|
			next if skip&&i!="FI"
			case
				when i=='IF'
					skip=true if pop==0
				when i=='FI'
					skip=false
				when i=='POP'
					pop
				when i=='+'
					push pop+pop
				when i=='-'
					a=pop
					b=pop
					push b-a
				when i=='='
					push (pop==pop)?1:0
				when i=='>'
					push (pop<pop)?1:0
				when i=='<'
					push (pop>pop)?1:0
				when i=='&'
					push (pop&pop)?1:0
				when i=='|'
					push (pop|pop)?1:0
				when i=='NOT'
					push pop==0?1:0
				when i=='NEG'
					push -pop
				when i=='DUP'
					push @stack[-1]
				when i=='SWAP'
					begin
						$stack[-2,2] = $stack[-2,2].reverse
					rescue
						sof
					end
				when i=='/'
					a=pop
					b=pop
					push b/a
				when i=='%'
					a=pop
					b=pop
					push b%a
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
				when i.to_i.to_s==i.to_s.strip # number
					push i.to_i
				else
					raise 'UNKNOWN WORD'
			end
		}
		if out.empty?
			out.push @stack[-1] if @stack[-1]
		end
		return out,@stack
	end
end
def stash(insts)
	stash=Stash.new
	begin
		ret,stack=stash.eval insts
		return ret
	rescue => e
		e.to_s
	end
end
addCommand('stash',->(args="",nick="",chan="",rawargs="",pipeargs=""){
	stash args.to_s
	},"Run stash code. (A language similar to Forth.)")

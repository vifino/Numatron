# Stash ( name wip ) is a wip stack based language, which borrows much from Forth.
class	Stash
	attr_reader :stack,:userwords
	def initialize(stack=[])
		@stack=stack
		@userwords={}
	end
	def sof
		raise("STACK UNDERFLOW")
	end
	def pop
		@stack.pop||sof
	end
	def push(a)
		@stack<<a
	end
	def run(insts="")
		worddef=skip=false
		word=out=[]
		chrbuf=""
		insts.upcase.split(/[[:space:]]/).each{|i|
			next if skip&&i!="FI"
			if worddef&&i!=';' then
				word<<i
				next
			end
			case
				when i=='IF'
					skip=true if pop==0
				when i=='FI'
					skip=false
				when i==":"
					worddef=true
					word=[]
				when i==";"
					worddef=false
					(word=[];raise("EMPTY WORD DEFINITION")) unless word && word.size>1
					(word=[];raise("NESTED WORD DEFINITION")) if word.include? ':'
					name, code = word.shift, word.join(' ')
					(word=[];raise("FUNCTION CALLS ITSELF")) if word.include? name
					@userwords[name.upcase] = lambda{puts @stack;puts code;run code;puts @stack}
					word = []
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
				when i=='OVER'
					push $stack[-2]||sof
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
				when (i=='PRINT' or i==".")
					out.push pop
				when (i=='PRNTBUF' or i=="EMIT")
					out.push chrbuf
				when i=='ERROR'
					raise 'ERROR'
				when i=='BREAK'
					if out.empty?
						out.push @stack[-1] if @stack[-1]
					end
					return out,@stack
				when i.to_i.to_s==i.to_s.strip # number
					push i.to_i
				else
					if @userwords[i] then
						puts 'MATCH'
						@userwords[i].call
					else
						raise "UNKNOWN WORD: #{i}"
					end
			end
		}
		if out.empty?
			out.push @stack[-1] if @stack[-1]
		end
		return out,@stack
	end
	def eval(a)
		run(a)
	end
end
def stash(insts)
	@stash=Stash.new
	begin
		ret,stack=@stash.eval(insts.to_s)
		#puts stack
		return ret
	rescue => e
		'ERROR: '+e.to_s
	end
end
addCommand('stash',->(args="",nick="",chan="",rawargs="",pipeargs=""){
	stash args.to_s
	},"Run stash code. (A language similar to Forth.)")

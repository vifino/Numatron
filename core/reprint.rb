# Reprint lines :D
# Made by vifino
print "\r"
def puts(t)
	t=t.chomp||""
	if @written==nil then
		print "#{t}"
	else
		print "\n#{t}"
	end
	@written ||=true
	@lastline=t
end
def reprint(t)
	t=t||""
	str=""
	rel=@lastline.length - t.length
	if rel>0 then
		str=" "*rel
	end
	print "\r#{t}"+str
end
def putsabove(t)
	reprint(t)
	puts @lastline
end

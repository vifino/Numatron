def reprintinit
  print "\r"
  @lastline||=""
  def putsbelow(t)
    if t then
      t=t.to_s.chomp||""
      if !@written then
        print "#{t.to_s}"
      else
        print "\n#{t.to_s}"
      end
      @written=true
      @lastline=t.to_s
    end
  end
  def p(t)
    if t then
      putsbelow t.inspect
    end
  end
  def reprint(t)
    if t then
      str=""
      rel=@lastline.length - t.length
      if rel>0 then
        str=" "*rel
      end
      print "\r#{t}"+str
    end
  end
  def puts(t)
    if t then
      reprint(t.to_s)
      putsbelow @lastline
    end
  end
end
reprintinit
putsbelow ">"
while true do
  sleep 1
  puts "test"
end

# Haskell, for haskell needs.
# Made by vifino
def haskell(code)
  rnd= ('a'..'z').to_a.shuffle[0,8].join
  tmpfile="/tmp/#{rnd}"
  `touch /tmp/sh_#{rnd}`
  f=File.open "/tmp/sh_#{rnd}","w"
  f.write code
  f.close
  o=sh("cat /tmp/sh_#{rnd}|runhaskell")
  `rm /tmp/sh_#{rnd}`
  return o
end
def haskcmd(args="",nick="",chan="",rawargs="",pipeargs="")
  if isPrivileged? nick then
    haskell args
  end
end
addCommand("haskell",:haskcmd,"Run haskell code, Admin only!")

# Do server checks on minecraft servers. WIP
def mccheck(server,port=25565)
	s = TCPSocket.open(server, port)
	s.puts "\xFE\x01"
  	repl = s.gets
	s.close

  query = repl[3,repl.length].force_encoding("utf-16be").encode("utf-8").split("\0")
  res = {}
  res[:pversion] = wuery[1]
  res[:sversion] = query[2]
	res[:version] = query[2]
  res[:motd] = query[3]
  res[:players] = {:online => query[4], :max => query[5]}
end

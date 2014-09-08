# Do server checks on minecraft servers. WIP
require 'socket'
def mcping(server,port=25565)
	port|=25565
	begin
		socket = TCPSocket.open(server, port)
	rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
		raise "Host unreachable."
	end
  socket.write([0xFE, 0x01, 0xFA].pack('CCC'))
	socket.write(['MC|PingHost'.length].pack('n') + 'MC|PingHost'.encode('utf-16be').force_encoding('ASCII-8BIT'))
  socket.write([7 + 2 * server.length].pack('n'))
  socket.write([74].pack('c'))
  socket.write([server.length].pack('n') + server.encode('utf-16be').force_encoding('ASCII-8BIT'))
  socket.write([port].pack('N'))
  if socket.read(1).unpack('C').first != 0xFF
    return 'Unexpected Server response packet'
  end
  len = socket.read(2).unpack('n').first
  resp = socket.read(len*2).force_encoding('utf-16be').encode('utf-8').split("\u0000")
  socket.close

  if resp.shift != "\u00A71"
    return 'Unexpected Server response fields'
  end

  return {
    :protocol_version => resp.shift.to_i,
    :minecraft_version => resp.shift,
    :motd => resp.shift,
    :current_players => resp.shift.to_i,
    :max_players => resp.shift.to_i
  }
end
def mccmd(args="",nick="",chan="",rawargs="",pipeargs="")
	server,port=args.split(" ",2)
	port=port.to_i||25565
	if server and port then
		ret=mcping(server,port)
		if ret.class==Hash then
			return "Version: #{ret[:minecraft_version].strip} | Players: #{ret[:current_players]}/#{ret[:max_players]} | MOTD: #{ret[:motd].strip.gsub(/[\r\n]/,"").gsub(/\t/," ")}"
		else
			return ret
		end
	else
		return "Invalid input."
	end
end
addCommand("mcping",:mccmd,"Ping a minecraft server.")

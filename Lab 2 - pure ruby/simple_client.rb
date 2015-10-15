require 'socket'

hostname = '127.0.0.1'
port = 8000
threads = []

20.times do |i|
  t = Thread.new do
    puts "Client Connection #{i}"
    s = TCPSocket.open(hostname, port)
    while true
      while line = s.gets # Read lines from socket
        puts line         # and print them
      end
    end
    #s.close             # close socket when done
  end
  threads.push(t)
end

threads.map(&:join)
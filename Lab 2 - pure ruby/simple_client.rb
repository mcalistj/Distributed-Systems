require 'socket'

hostname = '127.0.0.1'
port = 8000
threads = []

def test_kill_service(hostname, port, thread_num)         # Function to test behaviour of server to receiving
  puts "Client connection attempt number #{thread_num}"   # "KILL_SERVICE\n" if sent multiple times
  begin
    connection = TCPSocket.open(hostname, port)
    connection.print("KILL_SERVICE\n")
    response = connection.gets                            # Establishing a type of protocol
    puts response
    if connection && response then                        # Debugging line to test whether the server gets terminated
      puts "Succeeded #{thread_num}"
    else
      puts "CONNECTION #{thread_num} Failed"
    end
    connection.close                                      # close socket when done
  rescue
    puts "Connection #{thread_num} Failed"
  end
end

100.times do |i|
  t = Thread.new do
    test_kill_service(hostname, port, i)
  end
  threads.push(t)
end

threads.map(&:join)
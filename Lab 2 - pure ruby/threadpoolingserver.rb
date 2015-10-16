require 'socket'                      # Get sockets from stdlib
require 'thread'                      # Get 'Queue' class

class ThreadPool
  def initialize(size)
    @size = size                      # Number of threads 
    @connections = Queue.new          # Initialise instance of 'Queue'
    @pool = Array.new(@size) do |i|
      t = Thread.new do
        Thread.current[:id] = i
        catch(:exit) do
          loop do
            connection, args = @connections.pop
            connection.call(*args)
          end
        end
      end
    end 
  end
  
  def schedule(*args, &block)
    @connections << [block, args]      # << Alias of push
  end
  
  def kill_service(client, server)
    @connections.clear
    client.close
    server.close
    #delete(pool)
  end

end

tp = ThreadPool.new(10)
connectionNumber = 0
  
hostname = '127.0.0.1'
port = 8000

server = TCPServer.open(hostname, port)     # Socket to listen on port 8000
loop {                                      # Servers run forever
  begin 
    client = server.accept                    # Wait for a client to connect
    tp.schedule do client                     # The following block of code gets put in p.connections = our threadpool work
      sleep rand(2)                           # Do some work. Introducing the random time period simulates a scenario where "KILL_SERVICE\n" 
                                              # can kill the other working threads because they no longer appear to exit at the same time
      client.print "Connection Established"   # Need to incorporated some type of protocol
      line = client.gets                      # Read lines from socket
      puts line                               # and print them
      if line.include? "KILL_SERVICE\n" then
        tp.kill_service(client, server)
      end
      client.close                            # Disconnect from the client
    end
  rescue
    break
  end
}
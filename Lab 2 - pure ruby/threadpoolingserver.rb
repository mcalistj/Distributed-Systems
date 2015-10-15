require 'socket'                      # Get sockets from stdlib
require 'thread'                      # Get 'Queue' class

class ThreadPool
  def initialize(size)
    @size = size                      # Number of threads 
    @connections = Queue.new          # Initialise instance of 'Queue'
    @pool = Array.new(@size) do |i|
      Thread.new do
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
  
  def kill_service()
    puts @pool.length
    delete(@pool)
    delete(@connections)
    __END__
    puts "Hello"
    #abort("Message contains KILL_SERVICE\n")
  end
  
  def size_of_pool()
    return @pool.length
  end
end

tp = ThreadPool.new(10)
connectionNumber = 0
  
hostname = '127.0.0.1'
port = 8000

server = TCPServer.open(hostname, port)     # Socket to listen on port 8000
loop {                                      # Servers run forever
  client = server.accept                    # Wait for a client to connect
  tp.schedule do client                     # The following block of code gets put in p.connections = our threadpool work
    client.puts(Time.now.ctime)             # Send the time to the client
    connectionNumber += 1
    client.puts "Thread number #{connectionNumber} by thread #{Thread.current[:id]}"
    client.puts "Closing the connection. Bye!"
    client.close                            # Disconnect from the client
  end
}
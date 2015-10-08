require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 8000

s = TCPSocket.open(hostname, port)

puts "What non-spaced string of characters would you like echoed back?"  
STDOUT.flush  
message = gets.chomp
print message  

path = "/echo.php"
request = "GET #{path}?message=#{message} HTTP/1.0\r\n\r\n"
s.print(request)               # Send request
response = s.read              # Read complete response
print response

s.close               # Close the socket when done
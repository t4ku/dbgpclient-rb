require 'gserver'

class Debugger < GServer
  @session
  
  def serve(io)
    @session = DebuggerSession.new(io)
    @console = Console::Terminal.new
    
    puts "Connected"
    loop do
      #sleep 10
      if @session.has_response?
        puts "printing response"
        @session.print_response
        
        # this blocks
        line = @console.gets
        @session.evaluate(line)
      end
      break if @session.closed?
    end
  end
end

class DebuggerSession
  @session_id
  @io
  
  def initialize(io)
    @io = io
  end
  
  def send_cmd(cmd,arg)
    
  end
  
  def evaluate(line)
    puts "evaluating line #{line}"
    if line.match /status*/
      puts "status commnad"
      @io.write("status -i 1 \0")
    end
  end
      
  def print_response
    data = @io.readpartial(4096)
    puts ">>" + data
  end
  
  def has_response?
    IO.select([@io], nil, nil, 0.1)
  end
  
  def closed?
    if @io.closed?
      @io.close
      return true
    else
      return false
    end
  end
  
end

module Command
  class AbstractCommand
    
  end
  
  class Status < AbstractCommand
    
  end
  
end

module Console
  class AbstractConsole
    def gets
    end
  end
  
  class Terminal < AbstractConsole
    def gets
      STDIN.gets
    end
  end
end

a = Debugger.new(9000)
a.start
a.join
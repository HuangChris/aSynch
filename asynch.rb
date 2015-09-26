require 'thwait'

class Asynch
  attr_reader :threads, :queue, :run

  def initialize
    @queue = []
    @run = true
    @threads = []
    run_loop
    console
  end

  def run_loop
    @threads << Thread.new do
      @queue = []
      while @run
        to_run = @queue.shift
        if to_run
          puts "running method #{to_run[:method]}"
          to_run_object= to_run[:object] || Object
          to_run_object.send(to_run[:method], *to_run[:args])
        end
      end
    end
  end

  def end_run
    @run = false
  end

  def queue_method(method, object = nil, *args)
    method_def = {}
    method_def[:object] = object
    method_def[:method] = method
    method_def[:args] = args
    @queue << method_def
  end

  def set_timeout(wait, callback, object = nil, args = nil)
    @threads << Thread.new do
      sleep(wait)
      self.queue_method(callback, object, args)
    end
  end

  def quit #create an alias
    close_loop
  end

  def close_loop
    puts "will finish whats left to do, then end"
    end_run
    @queue.each do |method|
      to_run_object= method[:object] || Object
      to_run_object.send(method[:method], method[:args])
    end
  end

  def console
    command = ""
    Thread.new do
      while @run
        command = gets.chomp
        if command == "threads"
        end
        p self.send(command.to_sym)
      end
      self.close_loop
    end
  end
end

def my_puts(string)
  puts Time.now
  puts string
end

a = Asynch.new
p Time.now
a.queue_method(:sleep, nil, 1)
a.queue_method(:my_puts,nil, "msg 1: run a method after a 1sec wait")
a.set_timeout(5, :my_puts, nil, "msg 3: run 5 secs after msg 2")
a.queue_method(:puts,nil,"msg 2: run immediately after msg 1")
a.queue_method(:queue_method, a, :my_puts, nil, "recursive call" )
# Right now, close_loop kills the run loop before checking that any sleep loops
# are dead; implementing user_input loops will be a problem.
a.queue_method(:close_loop, a)
puts "this should print first"
ThreadsWait.all_waits(*a.threads)
p Time.now

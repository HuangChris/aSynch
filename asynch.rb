require 'thwait'
require 'byebug'

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
      while @run
        unless @queue.empty?
          to_run = @queue.shift
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

  def queue_method(method)
    @queue << method
  end

  def set_timeout(wait, callback)
    @threads << Thread.new do
      sleep(wait)
      self.queue_method(callback)
    end
  end

  def interval(wait_length, num_repeats = -1, callback)
    @threads << Thread.new do
      until num_repeats.zero?
        puts "waiting #{wait_length} secs"
        sleep(wait_length)
        self.queue_method(callback)
        num_repeats -= 1 unless num_repeats == -1
      end
    end
  end

  def question(prompt, callback)
    @threads << Thread.new do
      puts prompt
      answer = gets.chomp
      args.unshift(answer)
      puts args
      self.queue_method(callback)
    end
  end

  def quit #create an alias
    close_loop
  end

  def close_loop
    puts "will finish whats left to do, then end"
    while true
      break if threads.select { |thread| thread.alive? }.length == 1
    end
    p "stopping the runloop now"
    end_run
    @queue.each do |method|
      to_run_object= method[:object] || Object
      to_run_object.send(method[:method], method[:args])
    end
  end

  def method_missing(method, *args)
    # This is bad; but it does keep me from screwing up my console and
    # getting locked out of it.
    "Cannot run #{method} with args #{args}"
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
# a.queue_method(method: :sleep,args: 1)
a.queue_method(method: :my_puts, args: "msg 1: run a method after a 1sec wait")
# a.set_timeout(5,method: :my_puts,args: "msg 3: run 5 secs after msg 2")
# a.queue_method(method: :puts, args: "msg 2: run immediately after msg 1")
# a.queue_method(method: :queue_method, object: a, args: {method: :my_puts, args: "recursive call"} )
# a.question("Guess a number", method: :my_puts)
a.interval(1, 5, method: :my_puts,args: "test")
# a.queue_method(method: :close_loop,object: a)
a.set_timeout(2, method: :quit, object: a)
puts "this should print first"
ThreadsWait.all_waits(*a.threads)
p Time.now

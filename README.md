# aSynch

After starting JS, I looked into how to implement asynchronous operation
of functions in Ruby.  Essentially, I created a class to handle all
operations;  methods are called by inputing them into the operations
queue.  There is a Timeout function, which waits a set time before
adding callbacks to the queue; a question method which waits for user 
input before running the callback, and an interval method which would run
repeatedly until forever by default, or a given number of times if specified.

I also built a console for this class; you can call any of the instance 
methods(including `queue_method`, so with some tedium you can actually run
any method, but method chaining doesn't work). `close_loop`(to end the
program) is aliased as `quit`.

## To do:
* why does `close_loop` stop the run loop early?
  * When I call `quit` directly, it is will run no other commands until it
    quits the Asynch loop(expected behavior, as quit isn't threaded)
    * It also runs a command twice sometimes, as the runloop and the
        quits' loop to finish the queue start running simultaneously
  * When I queue a method to quit, it stops running the queue until the
      interval is complete
  * When I call `quit` through the console, it calls quit twice
  * `quit` will also need to kill any infinite intervals
* improve console--`method_missing`, make it play well w/ user questions

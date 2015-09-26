# aSynch

After starting JS, I looked into how to implement asynchronous operation
of functions in Ruby.  Essentially, I created a class to handle all
operations;  methods are called by inputing them into the operations
queue.  There is a Timeout function, which waits a set time before
adding callbacks to the queue; I would like to build a question
method which waits for user input before running the callback, and an
interval method which would run repeatedly until forever by default, or
a given number of times if specified.

I also built a console for this class; you can call any of the instance methods(including queue_method, so with some tedium you can actually run
any method, but method chaining doesn't work). Closes_loop(to end the
program) is aliased as "quit".

## To do:
* why does close_loop stop the run loop early?
* improve console--method_missing, make it play well w/ user questions

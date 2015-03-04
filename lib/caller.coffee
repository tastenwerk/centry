module.exports = ->
  stack = getStack()

  # Remove superfluous function calls on stack
  stack.shift() # getCaller --> getStack
  stack.shift() # omfg --> getCaller

  # Return caller's caller
  stack[2].receiver

getStack = ->
  # Save original Error.prepareStackTrace
  origPrepareStackTrace = Error.prepareStackTrace

  # Override with function that just returns `stack`
  
  Error.prepareStackTrace = (_, stack)->
    stack

  # Create a new `Error`, which automatically gets `stack`
  err = new Error()

  # Evaluate `err.stack`, which calls our new `Error.prepareStackTrace`
  stack = err.stack

  # Restore original `Error.prepareStackTrace`
  Error.prepareStackTrace = origPrepareStackTrace

  # Remove superfluous function call on stack
  stack.shift() # getStack --> Error

  stack
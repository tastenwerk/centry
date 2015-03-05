path          = require 'path'
join          = path.join
basename      = path.basename
dirname       = path.dirname

module.exports.getCallerFilename = ->

  try

    err =  new Error()
    callerfile = undefined
    currentfile = undefined

    Error.prepareStackTrace = (err, stack)-> return stack

    currentfile = err.stack.shift().getFileName()

    while err.stack.length
      callerfile = err.stack.shift().getFileName()
      return callerfile if(currentfile != callerfile)

  catch

  undefined

module.exports.getCallerDirname = ->
  dirname module.exports.getCallerFilename()
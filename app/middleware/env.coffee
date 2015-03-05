path              = require 'path'
join              = path.join
env = {}

env.defaults = (req,res,next)->
  res.locals.env = process.env['NODE_ENV']
  next()

module.exports = env
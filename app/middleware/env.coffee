path          = require 'path'
join          = path.join
assets        = require join( __dirname, '..', '..', 'lib/assets' )
env = {}

env.defaults = (req,res,next)->
  res.locals.env = process.env['NODE_ENV']
  res.locals.assets = assets.asObject()
  next()

module.exports = env
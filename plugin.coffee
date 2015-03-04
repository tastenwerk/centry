path          = require 'path'
_             = require 'lodash'

join          = path.join
basename      = path.basename
dirname       = path.dirname

caller        = require join( __dirname, 'lib/caller' )
logger        = require join( __dirname, 'lib/logger' )

registry = []

module.exports.register = (pluginPath)->
  pluginPath = pluginPath || dirname(caller().filename)
  pluginName = basename(pluginPath, '.coffee')
  registry.push { name: pluginName, path: pluginPath }
  logger.info 'plugin registered: %s', pluginName

module.exports.each = (fn)->
  registry.forEach fn

module.exports.map = (fn)->
  registry.map fn
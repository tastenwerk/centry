path                = require 'path'
_                   = require 'lodash'

join                = path.join
basename            = path.basename

utils               = require join( __dirname, 'lib/utils' )
getCallerDirname    = utils.getCallerDirname
logger              = require join( __dirname, 'lib/logger' )

registry = []

module.exports.register = (pluginPath)->
  pluginPath = pluginPath || getCallerDirname()
  pluginName = basename(pluginPath, '.coffee')
  registry.push { name: pluginName, path: pluginPath }
  logger.info 'plugin registered: %s', pluginName

module.exports.each = (fn)->
  registry.forEach fn

module.exports.map = (fn)->
  registry.map fn
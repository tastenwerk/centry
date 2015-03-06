fs                  = require 'fs'
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

module.exports.assetPaths = ->
  assetPaths = []
  registry.forEach (plugin)->
    getPath( plugin, 'js', assetPaths )
    getPath( plugin, 'css', assetPaths )
  addApplicationBowerComponentsPath(assetPaths)
  assetPaths

getPath = (plugin, type, assetPaths)->
  p = join(plugin.path, "/app/assets/#{type}")
  assetPaths.push(p) if fs.existsSync( p )

addApplicationBowerComponentsPath = (assetPaths)->
  assetPaths.push join( process.cwd(), 'bower_components' )

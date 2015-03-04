fs            = require 'fs'

glob          = require 'glob'
path          = require 'path'
join          = path.join

plugin        = require join(__dirname,'..','plugin')

module.exports.asObject = ->
  assetPaths = getAssetPaths()
  {
    styles: getStyles(assetPaths)
    scripts: getScripts(assetPaths)
  }

getStyles = (assetPaths)->
  files = []
  assetPaths.forEach ( assetPath)->
    glob.sync( "#{assetPath}/**/*.css" )
      .forEach (filename)->
        files.push filename.replace(assetPath,'')
  files

getScripts = (assetPaths)->
  files = []
  assetPaths.forEach ( assetPath)->
    glob.sync( "#{assetPaths}/**/*.(js.coffee|js)" )
      .forEach (filename)->
        files.push filename.replace(assetPath,'')
  files

getAssetPaths = ->
  assetPaths = []
  plugin.each (data)->
    pluginAssetPath = join( data.path, 'public', 'assets' )
    return unless fs.existsSync pluginAssetPath
    assetPaths.push pluginAssetPath
  assetPaths

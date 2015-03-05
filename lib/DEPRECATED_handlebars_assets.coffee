fs            = require 'fs'

glob          = require 'glob'
path          = require 'path'
join          = path.join

plugin        = require join(__dirname,'..','plugin')

compiler      = require 'ember-template-compiler'

module.exports.asObject = ->
  return {}
  assetPaths = getAssetPaths()
  {
    templates: getTemplates(assetPaths)
  }


getTemplates = (assetPaths)->
  templates = []
  assetPaths.forEach ( assetPath )->
    glob.sync( "#{assetPaths}/templates/**/*.hbs" )
      .forEach (filename)->
        template = fs.readFileSync(filename).toString()
        input = compiler.precompile(template,false)
        name = filename.replace(assetPath+'/templates/','').replace('.hbs','')
        templates.push "Ember.TEMPLATES['#{name}'] = Ember.Handlebars.template(" + input + ");"
  console.log 'templates', templates
  templates

getAssetPaths = ->
  assetPaths = []
  plugin.each (data)->
    pluginAssetPath = join( data.path, 'app', 'assets' )
    return unless fs.existsSync pluginAssetPath
    assetPaths.push pluginAssetPath
  assetPaths

process.env.NODE_ENV  = process.env.NODE_ENV || 'development'
express               = require('express')
settings              = require(process.cwd()+'/config/env.'+process.env.NODE_ENV)
session               = require 'express-session'
FileStore             = require('session-file-store')(session)
bodyParser            = require 'body-parser'
moment                = require 'moment'
lodash                = require 'lodash'
swig                  = require 'swig'
assets                = require 'connect-assets'

fs                    = require 'fs'
path                  = require 'path'
join                  = path.join

logger                = require join(__dirname,'lib/logger')
plugin                = require join(__dirname,'plugin')
plugin.register()

app = express()

app.use session
  store: new FileStore()
  secret: '6sjAPF7DnqmcIus_H7JHCg'
  resave: false
  saveUninitialized: false

app.use express.static(__dirname + '/public')

app.use assets
  paths: plugin.assetPaths()

app.use bodyParser.urlencoded({ extended: true })

# view engine settings
app.engine 'html.swig', swig.renderFile
app.set 'view cache', false
app.set 'view engine', 'html.swig'

app.set 'views', join(__dirname,'app','views')

swig.setDefaults
  cache: false
  autoescape: false

admin = require join(__dirname,'app','routers','admin')
app.use '/admin', admin

# routersDir = join(__dirname,'app','routers')
# fs.readdirSync routersDir
#   .forEach (filename)->
#     require join( routersDir, filename )

module.exports.app = app

module.exports.start = ->
  server = app.listen settings.port, ->
    host = server.address().address
    port = server.address().port
    logger.info "centry up at http://#{host}:#{port}"

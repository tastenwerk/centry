process.env.NODE_ENV  = process.env.NODE_ENV || 'development'
express               = require('express')
settings              = require(process.cwd()+'/config/env.'+process.env.NODE_ENV)
session               = require 'express-session'
FileStore             = require('session-file-store')(session)
bodyParser            = require 'body-parser'
moment                = require 'moment'
lodash                = require 'lodash'
swig                  = require 'swig'

fs                    = require 'fs'
path                  = require 'path'
join                  = path.join

app = express()

app.use session
  store: new FileStore()
  secret: '6sjAPF7DnqmcIus_H7JHCg'
  resave: false
  saveUninitialized: false

app.use express.static(__dirname + '/public')
app.use bodyParser.urlencoded({ extended: true })

# view engine settings
app.engine 'html', swig.renderFile
app.set 'view cache', false

swig.setDefaults
  cache: false

app.get '/',
  (req,res)->
    res.send 'root ok'

auth = require join(__dirname,'app','routers','auth')
app.use '/auth', auth
# routersDir = join(__dirname,'app','routers')
# fs.readdirSync routersDir
#   .forEach (filename)->
#     require join( routersDir, filename )

module.exports.app = app

module.exports.start = ->
  server = app.listen settings.port, ->
    host = server.address().address
    port = server.address().port
    console.log 'centry up at http://%s:%s', host, port

# coffeelint: disable=max_line_length

fs                    = require 'fs'
path                  = require 'path'
join                  = path.join
basename              = path.basename

middleware = {}

middlewareBase = join(__dirname,'app','middleware')

fs.readdirSync middlewareBase
  .forEach (filename)->
    middleware[basename(filename,'.coffee')] = require( join( middlewareBase, filename ) )

module.exports = middleware
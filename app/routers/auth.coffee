express       = require 'express'
path          = require 'path'
join          = path.join

router        = express.Router()

router.get '/login',
  ( req, res )->
    res.render join( __dirname, '..', 'views', 'auth', 'login.swig' )

module.exports = router
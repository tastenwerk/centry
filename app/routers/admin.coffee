express       = require 'express'
path          = require 'path'
join          = path.join
middleware    = require join(__dirname,'..','..','middleware')
env           = middleware.env
auth          = middleware.auth

router        = express.Router()

router.use env.defaults

router.get '/',
  (req, res)->
    res.render 'admin/index'

module.exports = router
auth = {}

auth.check = (req,res,next)->
  return res.redirect '/admin/login' unless req.user
  next()

module.exports = auth
Centry.Router.map ->
  @route 'index', path: '/'
  @resource 'sessions', ->
    @route 'login'
    @route 'forgot_password'

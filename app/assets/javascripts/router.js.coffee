# For more information see: http://emberjs.com/guides/routing/

Centry.Router.map ->
  @route 'index', path: '/'
  @resource 'sessions', ->
    @route 'login'
    @route 'logout'
    @route 'forgot_password'
    @route 'signup'
    @route 'confirm', path: 'confirm/:id/:key'

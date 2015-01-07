# For more information see: http://emberjs.com/guides/routing/

Centry.Router.map ->
  @route 'index', path: '/'
  @resource 'sessions', ->
    @route 'login'
    @route 'logout'
    @route 'forgot_password'
    @route 'reset_password', path: 'reset_password/:id/:confirmation_key'
    @route 'signup'
    @route 'confirm', path: 'confirm/:id/:confirmation_key'
  @resource 'accounts', ->
    @route 'mine'
    @route 'privacy'
    @route 'admin'
    @route 'new'
    @route 'edit', path: ':id'

#
# AuthenticatedRoute
#
Centry.AuthenticatedRoute = Ember.Route.extend
  init: ->
    @_super()
    if Ember.$.cookie('access_token')
      Ember.$.ajaxSetup
        headers: { 'Authorization': 'Bearer ' + Ember.$.cookie('access_token') }

  beforeModel: (transition)->
    userId = Ember.$.cookie('user_id')
    unless userId
      @controllerFor('sessions.login').setProperties( token: null, userId: null )
      return @redirectToLogin(transition)
    @store.find 'user', userId
      .then (user)=>
        @redirectToLogin(transition) unless user
        @checkAdmin(user) if @get('requireAdmin')
        user.setLang()
        $('body').removeClass('authorization-required')
      .catch (error)=>
        console.log 'error caught', error
        @controllerFor('sessions.login').reset()
        @transitionTo 'sessions.login'

  checkAdmin: (user)->
    return if user.get('admin')
    @transitionTo 'index'

  redirectToLogin: (transition)->
    @controllerFor('sessions.login').set('attemptedTransition', transition)
    @transitionTo 'sessions.login'

  actions:

    editContent: (obj, objName, routeName)->
      editController = @controllerFor(routeName.replace('.','_'))
      editController.set(objName, obj)
      @render routeName,
        into: 'application'
        outlet: 'modal'
        controller: editController

    openMiniModal: (name, controller)->
      @render name,
        into: 'application'
        outlet: 'mini-modal'
        controller: controller
      Em.run.later ->
        $('.modal').modal()
        .on 'shown.bs.modal', ->
          $(this).find('input.js-get-focus').focus()

    closeModal: ->
      @disconnectOutlet
        outlet: 'modal'
        parentView: 'application'

    closeMiniModal: ->
      @disconnectOutlet
        outlet: 'mini-modal'
        parentView: 'application'

    goTo: (route)->
      @transitionTo route
      true

# common settings

# language
window.LANG = $('html').attr('lang')

Ember.I18n.locale = LANG
Ember.I18n.translations = Ember.I18n.availableTranslations[LANG]
# inject <attr>Translation into {{input }} helper
Ember.TextField.reopen(Ember.I18n.TranslateableAttributes)

moment.locale(LANG)

$.cookie.json = true

Centry.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api/v1' 
  pathForType: (type)->
    decamelized = Ember.String.decamelize(type)
    Ember.String.pluralize(decamelized)

Centry.ApplicationStore = DS.Store.extend()

Centry.Organization = DS.Model.extend
  name:             DS.attr 'string'
  users:            DS.hasMany 'users'
  
#
# User
#
Centry.User = DS.Model.extend
  username:         DS.attr 'string'
  firstname:        DS.attr 'string'
  lastname:         DS.attr 'string'
  email:            DS.attr 'string'
  password:         DS.attr 'string'
  password_confirm: DS.attr 'string'
  api_keys:         DS.hasMany 'api_key'
  role:             DS.attr 'string'
  organization:     DS.belongsTo 'organization'

#
# ApiKey
#
Centry.ApiKey = DS.Model.extend
  token:        DS.attr 'string'
  expires_at:   DS.attr 'date'
  user:         DS.belongsTo 'user', async: true

Centry.ApiKeyAdapter = DS.LSAdapter.extend
  namespace:    'centry-auth-keys'

Centry.UserAdapter = Centry.ApplicationAdapter.extend()

#
# ApplicationRoute
#
Centry.ApplicationRoute = Ember.Route.extend
  actions:
    logout: ->
      @controllerFor('sessions').reset()
      @transitionTo('sessions')

#
# AuthenticatedRoute
#
Centry.AuthenticatedRoute = Ember.Route.extend
  beforeModel: (transition)->
    if Ember.isEmpty @controllerFor('sessions').get('token')
      @redirectToLogin(transition)

  redirectToLogin: (transition)->
    @controllerFor('sessions').set('attemptedTransition', transition)
    @transitionTo 'sessions'

  # actions:
  #   # recover from any error that may happen during the transition to this route
  #   error: (reason, transition)->
  #     if (reason.status is 401)
  #       return @redirectToLogin(transition)
  #     console.log('unknown problem', transition, reason)

#
# SessionsRoute
#
Centry.SessionsRoute = Ember.Route.extend
  setupController: (controller, context)->
    controller.reset()

  beforeModel: (transition)->
    return if Ember.isEmpty(@controllerFor('sessions').get('token'))
    @transitionTo '/index'

#
# SessionsController
#
Centry.SessionsController = Ember.Controller.extend
  init: ->
    @_super()
    if Ember.$.cookie('access_token')
      Ember.$.ajaxSetup
        headers: { 'Authorization': 'Bearer ' + Ember.$.cookie('access_token'), 'Organization_id': Ember.$.cookie('organization_id') }

  login: ''
  password: ''

  attemptedTransition: null

  token: Ember.$.cookie('access_token'),

  currentUser: Ember.$.cookie('auth_user'),

  tokenChanged: (->
    if Ember.isEmpty(@get('token'))
      Ember.$.removeCookie('access_token')
      Ember.$.removeCookie('auth_user')
    else
      Ember.$.cookie('access_token', @get('token'))
      Ember.$.cookie('auth_user', @get('currentUser'))
  ).observes 'token'

  reset: ->
    @setProperties
      login: null
      password: null
      token: null
      currentUser: null

    Ember.$.ajaxSetup
      headers: { 'Authorization': 'Bearer none', 'Organization_id': null }

Centry.SessionsIndexController = Centry.SessionsController.extend

  actions:
  
    loginUser: ->
      data = @getProperties('login', 'password')
      attemptedTrans = @get('attemptedTransition')

      @setProperties
        login: null,
        password: null

      Ember.$.post('/api/v1/auth', data)
        .then (response)=>
          Ember.$.ajaxSetup
            headers: { 'Authorization': 'Bearer ' + response.api_key.token, 'Organization_id': response.api_key.organization_id }
          key = @get('store').createRecord('apiKey', response.api_key )
          @store.find('user', response.api_key.user_id)
            .then (user)=>
              @setProperties
                token: response.api_key.token
                currentUser: user
              key.set('user', user)
              key.save()
              user.get('apiKeys').content.push(key)
              
              if attemptedTrans
                attemptedTrans.retry()
                @set('attemptedTransition', null)
              else
                @transitionToRoute 'index'
        .fail (error)->
          if error.status is 401
            alert("wrong user or password, please try again")

#
# ApplicationController
#
Centry.ApplicationController = Ember.Controller.extend
  needs:  ['sessions']
  
  currentUser: Em.computed ->
    @get('controllers.sessions.currentUser')
  .property 'controllers.sessions.currentUser'

  isAuthenticated: Em.computed ->
    !Ember.isEmpty @get('controllers.sessions.currentUser')
  .property 'controllers.sessions.currentUser'


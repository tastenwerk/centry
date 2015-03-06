Centry.SessionsController = Ember.Controller.extend

  login: ''
  password: ''

  openRegistration: (if typeof(CAMINIO_SHOW_OPEN_REG_LINK) == 'boolean' then CAMINIO_SHOW_OPEN_REG_LINK else true)

  availableLocales: [{ label: 'Deutsch', value: 'de'}, { label: 'English', value: 'en' }]
  availableRoles: [
    { label: Em.I18n.t('roles.user'), value: 'user' }
    { label: Em.I18n.t('roles.editor'), value: 'editor' }
    { label: Em.I18n.t('roles.admin'), value: 'admin' }
  ]
  selectedLocale: Ember.I18n.locale
  observeSelectedLocale: (->
    return unless @get('selectedLocale')
    Ember.$.cookie 'locale', @get('selectedLocale')
    Em.I18n.locale = @get('selectedLocale')
    location.reload()
  ).observes 'selectedLocale'

  attemptedTransition: null

  token: Ember.$.cookie('access_token')

  userId: Ember.$.cookie('user_id')

  organizationId: Ember.$.cookie('organization_id')

  tokenChanged: (->
    if Ember.isEmpty(@get('token'))
      Ember.$.removeCookie('access_token')
      Ember.$.removeCookie('user_id')
      # Ember.$.removeCookie('organization_id')
    else
      Ember.$.cookie('access_token', @get('token'))
      Ember.$.cookie('user_id', @get('userId'))
      # Ember.$.cookie('organization_id', @get('organizationId'))
  ).observes 'token', 'userId'

  reset: ->
    @setProperties
      login: null
      password: null
      token: null
      userId: null
      organizationId: null
    
    Ember.$.ajaxSetup
      headers: { 'Authorization': 'Bearer none', 'Organization_id': undefined }

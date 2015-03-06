Centry.SessionsLoginController = Centry.SessionsController.extend

  needs: ['sessions']

  actions:
  
    loginUser: ->
      data = @getProperties('login', 'password')
      attemptedTrans = @get('attemptedTransition')

      @setProperties
        login: null
        password: null
        message: null

      Ember.$.post('/centry/auth/login', data)
        .then (response)=>
          Ember.$.ajaxSetup
            headers: { 'Authorization': 'Bearer ' + response.api_key.token }
          # @get('store').find('apiKey').forEach (apiKey)-> apiKey.destroyRecord()
          # key = @get('store').createRecord('apiKey', response.api_key )
          @get('controllers.sessions').set('token', response.api_key.token)
          @store.find('user', response.api_key.user_id)
            .then (user)=>
              @get('controllers.sessions').set('organizationId', user.get('organizations.firstObject.id'))
              @get('controllers.sessions').set('userId', user.get('id'))
              Ember.$.ajaxSetup
                headers: { 'Organization_id': @get('controllers.sessions.organizationId') }
              console.log 'still attempt to trans', attemtpedTrans
              if attemptedTrans
                attemptedTrans.retry()
                console.log 'attempt retry was done'
                @set('attemptedTransition', null)
              else
                @transitionToRoute 'index'
        .fail (error)=>
          if error.status is 401
            @set('message', Em.I18n.t('errors.login_failed'))
            $('input[type=text]:visible:first').focus()

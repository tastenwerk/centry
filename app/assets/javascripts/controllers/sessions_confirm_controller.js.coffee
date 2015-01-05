Centry.SessionsConfirmController = Ember.ObjectController.extend Centry.Validations,

  needs: ['sessions']

  validate:
    confirmation_code:
      required:
        message: Em.I18n.t('errors.code_required')

  actions:

    checkCode: ->
      return unless @isValid()
      Ember.$.post("#{Centry.get('apiHost')}/users/#{@get('content.id')}/confirm", @getProperties('confirmation_code', 'confirmation_key'))
        .then (response)=>
          @store.find('user', @get('id'))
            .then (user)=>
              controllers.get('sessions').setProperties
                token: response.api_key.token
                currentUser: user
              key = @get('store').createRecord('apiKey', response.api_key )
              key.set('user', user)
              key.save()
              # user.get('api_keys').content.push(key)
              @transitionToRoute 'accounts.mine'
        .fail (err)=>
          json = err.responseJSON
          if( err.status == 409 )
            @set 'valid', false
            if( json.error == 'InvalidCode' )
              @set 'message', Em.I18n.t('errors.invalid_code')
              @set 'errors.code', true
            if( json.error == 'InvalidKey' )
              @set 'message', Em.I18n.t('errors.key_invalid_or_expired')
              @set 'errors.code', true
            else
              @set 'message', Em.I18n.t('errors.unknown')


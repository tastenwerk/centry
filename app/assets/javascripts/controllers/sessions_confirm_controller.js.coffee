Centry.SessionsConfirmController = Ember.ObjectController.extend Centry.Validations,

  validate:
    confirmation_code:
      required:
        message: Em.I18n.t('errors.code_required')

  actions:

    checkCode: ->
      return unless @isValid()
      Ember.$.post("#{Centry.get('apiHost')}/users/#{@get('content.id')}/confirm", @get('content').getProperties('confirmation_code', 'confirmation_key'))
        .then (res)=>
          @transitionToRoute 'dashboard'
        .fail (err)=>
          json = err.responseJSON
          if( err.status == 409 )
            @set 'valid', false
            if( json.error == 'InvalidCode' )
              @set 'message', Em.I18n.t('errors.invalid_code')
              @set 'errors.code', true
            else
              @set 'message', Em.I18n.t('errors.unknown')


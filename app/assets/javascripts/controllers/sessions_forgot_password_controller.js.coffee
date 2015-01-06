Centry.SessionsForgotPasswordController = Ember.ObjectController.extend Centry.Validations,

  needs: ['sessions']

  validate:
    email:
      required:
        message: Em.I18n.t('errors.email_required')
      match:
        regexp: /.+@.+/
        message: Em.I18n.t('errors.not_an_email_address')

  done: false

  actions:

    sendConfirmationKey: ->
      return unless @isValid()
      Ember.$.post("#{Centry.get('apiHost')}/users/reset_password_request", @getProperties('email'))
        .then (res)=>
          $('.alert').text( Em.I18n.t('link_sent', email: @get('email')) )
          @set('done',true)
        .fail (err)=>
          json = err.responseJSON
          if( err.status == 404 )
            @set 'valid', false
            @set 'message', Em.I18n.t('errors.email_unknown', email: @get('content.email'))
            @set 'errors.email', true


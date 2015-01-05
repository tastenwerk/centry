Centry.SessionsConfirmView = Centry.FadedView.extend
  didInsertElement: ->
    Ember.run.later =>
      $('input[type=text]:first').focus()
    , 500

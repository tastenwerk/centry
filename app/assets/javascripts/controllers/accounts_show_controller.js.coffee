Centry.AccountsShowController = Ember.ObjectController.extend
  needs: ['application']

  actions:
    save: (callback, scope)->
      @get('content')
        .save()
        .then ->
          callback.call(scope)

Centry.AccountsMineController = Centry.AccountsShowController.extend()

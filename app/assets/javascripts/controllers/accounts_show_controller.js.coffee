Centry.AccountsShowController = Ember.ObjectController.extend
  actions:
    save: ->
      @get('content')
        .save()

Centry.AccountsMineController = Centry.AccountsShowController.extend()

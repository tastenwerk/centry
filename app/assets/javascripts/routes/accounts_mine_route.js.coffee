Centry.AccountsMineRoute = Centry.AuthenticatedRoute.extend
  model: ->
    @controllerFor('sessions').get('currentUser')
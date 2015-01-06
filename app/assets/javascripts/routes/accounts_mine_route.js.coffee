Centry.AccountsMineRoute = Centry.AuthenticatedRoute.extend
  model: (params)->
    @controllerFor('application').get('currentUser')

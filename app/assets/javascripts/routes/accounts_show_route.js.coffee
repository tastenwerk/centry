Centry.AccountsShowRoute = Centry.AuthenticatedRoute.extend
  model: (params)->
    @store.find('user', params.id)

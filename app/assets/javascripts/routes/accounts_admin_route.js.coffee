Centry.AccountsAdminRoute = Centry.AuthenticatedRoute.extend
  model: ->
    @store.find('user')

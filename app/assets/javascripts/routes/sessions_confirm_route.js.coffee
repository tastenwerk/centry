Centry.SessionsConfirmRoute = Ember.Route.extend
  model: (params)->
    Ember.Object.create
      confirmation_code: ''
      confirmation_key: params.key
      id: params.id

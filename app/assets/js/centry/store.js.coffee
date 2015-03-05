Centry.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api/v1'
  pathForType: (type)->
    decamelized = Ember.String.decamelize(type)
    Ember.String.pluralize(decamelized)


Centry.ApplicationStore = DS.Store.extend()
Centry.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'centry/api'
  pathForType: (type)->
    decamelized = Ember.String.decamelize(type)
    Ember.String.pluralize(decamelized)


Centry.ApplicationStore = DS.Store.extend()
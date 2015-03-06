#= require_self
#= require ./store
#= require ./router
#= require ./locales
#= require_tree ./routes
#= require_tree ./controllers

window.Centry = Ember.Application.create
  LOG_TRANSITIONS: true
  LOG_BINDINGS: true
  LOG_VIEW_LOOKUPS: true
  LOG_STACKTRACE_ON_DEPRECATION: true
  LOG_VERSION: true
  debugMode: true

#= require_tree ./locales

window.LANG = $('html').attr('lang')
Ember.I18n.locale = (Ember.$.cookie('locale') || LANG).replace(/\"/g,'')
Ember.I18n.translations = Ember.I18n.availableTranslations[Ember.I18n.locale]

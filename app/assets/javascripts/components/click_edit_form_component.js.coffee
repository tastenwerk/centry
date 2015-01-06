Centry.ClickEditFormComponent = Ember.Component.extend

  value: ''

  origValue: ''

  editValue: false

  labelTranslation: Em.computed ->
    Em.I18n.t( @get('label') )

  editValueObserver: (->
    Em.run.later =>
      @$('input[type=text]').focus()
    , 10
  ).observes 'editValue'

  hasChanges: Em.computed ->
    console.log 'orig', @get('origValue'), 'new', @get('value')
    @get('origValue') != @get('value')
  .property 'origValue', 'value'

  valueObserver: (->
    @set('origValue', @get('value')) unless @get('origValue')
    return if @get('origValue') == @get('value')
  ).observes 'value'

  click: ->
    other = Centry.get('currentClickEdit') 
    if other && other != @
      other.set('editValue',false)
    @set('editValue', !@get('editValue'))
    Centry.set('currentClickEdit', @)

  actions:

    saveChanges: ->
      @get('parentController').send('save')

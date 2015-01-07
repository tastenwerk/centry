Centry.ClickEditFormComponent = Ember.Component.extend

  init: ->
    @_super()
    @set('origValue', '')
    @set('origValue', @get('value')) unless Em.isEmpty(@get('value'))
    @set('value','') if Em.isEmpty(@get('value'))

  editValue: false

  labelTranslation: Em.computed ->
    Em.I18n.t( @get('label') )

  editValueObserver: (->
    Em.run.later =>
      @$('input[type=text]').focus()
    , 10
  ).observes 'editValue'

  hasChanges: Em.computed ->
    @get('origValue') != @get('value')
  .property 'origValue', 'value'

  valueObserver: (->
    return if @get('origValue') == @get('value')
  ).observes 'value'

  saveCallback: ->
    @set('editValue',false)
    @set('valueSaved', true)
    Ember.run.later =>
      @set('valueSaved',false)
      @set('origValue', @get('value'))
    , 2000

  actions:

    saveChanges: ->
      @get('parentController').send('save', @saveCallback, @)

    cancelEdit: ->
      @set('editValue',false)
      Centry.get('currentClickEdit', null)

    edit: ->
      return if @get('editValue')
      other = Centry.get('currentClickEdit') 
      if other && other != @
        other.set('editValue',false)
      @set('editValue', true)
      Centry.set('currentClickEdit', @)


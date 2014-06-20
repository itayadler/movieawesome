MA.TypeaheadTextField = Ember.View.extend(Ember.ViewTargetActionSupport,
  attributes: ['remote', 'local', 'name', 'prefetch']
  events: ['typeahead:autocompleted', 'typeahead:selected', 'typeahead:closed', 'typeahead:opened', 'typeahead:initialized']

  type: 'text'
  tagName: 'input'
  classNames: 'autocomplete'

  didInsertElement: ->
    options = {}
    
    @get('attributes').forEach((attr) =>
      options[attr] = @[attr] if @[attr] 
    )

    @$().typeahead(options)
    @$().addClass(@class) if @class
    @$().on('typeahead:selected', ($event, datum)=>
      @controller.send('query', datum)
    )
    @controller.addObserver('selectedMovie', =>
      @$().val(@controller.get('selectedMovie').value)
    )

  keyPress: (e)->
    if e.keyCode == 13
      console.log 'enter'
)

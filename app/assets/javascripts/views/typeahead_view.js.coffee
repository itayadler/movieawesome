MA.TypeaheadTextField = Ember.View.extend
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
      Ember.set(@, 'selectedMovie', datum)
    )



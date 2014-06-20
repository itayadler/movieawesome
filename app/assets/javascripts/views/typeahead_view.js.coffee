MA.TypeaheadTextField = Ember.View.extend(Ember.ViewTargetActionSupport,
  attributes: ['remote', 'local', 'name', 'prefetch']
  events: ['typeahead:autocompleted', 'typeahead:selected', 'typeahead:closed', 'typeahead:opened', 'typeahead:initialized']

  type: 'text'
  tagName: 'input'
  classNames: 'autocomplete'

  didInsertElement: ->
    options = {
      remote:
        url: "http://sg.media-imdb.com/suggests/%QUERY.json"
        dataType: 'jsonp'
        jsonp: false
        jsonpCallback: "imdb$%QUERY"
        replace: (url, query)=>
          url.replace("%QUERY", @_imdbCompatibleQuery(query))
        filter: (parsedResponse)=>
          parsedResponse.d.map((row)->
            value: row.l
            production_year: row.y
            thumb: row.i
          )
    }
    
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

  _imdbCompatibleQuery: (query)->
    query = query.toLowerCase()
    query = query.replace(/[ ]/g, '_')
    "#{query[0]}/#{query}"

  keyPress: (e)->
    if e.keyCode == 13
      console.log 'enter'
)

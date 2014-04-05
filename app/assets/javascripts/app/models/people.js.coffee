app.factory "People"
, ['$http', 'Settings'
, ($http, settings) ->

  class People
    self = null # Hack because it seems I can't use the '@' notation properly

    constructor: (@query, @type) ->
      self = this
      @items = new Array()
      @pending = false
      @no_more_result = false
      @page = 1

    success: (data) ->
      self.no_more_result = data['people'].length == 0

      i = 0
      while i < data['people'].length
        self.items.push data['people'][i]
        i++

      self.pending = false
      self.page += 1  # Should use Link HTTP Header

    loadMore: ->
      return if @pending || @no_more_result

      @pending = true
      
      url = settings.apiBaseUri+"/people/search?q=" + @query +
            "&type=" + @type + "&page=" + @page

      $http({method: 'GET', url: url})
      .success(@success)

]
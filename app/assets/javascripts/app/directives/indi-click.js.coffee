# Fork of http://ericpanorel.net/2013/08/31/angularjs-button-directive-with-busy-indicator/

app.directive "indiClick",
["$parse",
($parse) ->

  link = (scope, element, attr) ->
    fn = $parse(attr["indiClick"]) # "compile" the bound expression to our directive
    target = element[0]
    
    # implement our click handler
    element.on "click", (event) ->
      oldWidth = element.width()
      height = element.height()

      # customize this "resizing and coloring" algorithm
      opts =
        length: Math.round(height / 3)
        radius: Math.round(height / 5)
        width: Math.round(height / 10),
        color: element.css("color"),
        left: 0

      scope.$apply ->
        attr.$set "disabled", true
        element.width oldWidth + oldWidth / 2 # make room for spinner
        spinner = new Spinner(opts).spin(target)

        # expects a promise
        # http://docs.angularjs.org/api/ng.$q
        fn(scope,
          $event: event
        ).then ((fct) ->
          element.width oldWidth # restore size
          spinner.stop()
          attr.$set "disabled", false
          fct(target)

        ), (fct) ->
          element.width oldWidth
          spinner.stop()
          fct(target)


    return (
      link: link
      restrict: "A"
    )
]
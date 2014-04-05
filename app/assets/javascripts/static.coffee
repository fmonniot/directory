#= require jquery
#= require twitter/bootstrap/affix
#= require twitter/bootstrap/scrollspy
#= require highlight

$body = $(document.body)

$body.scrollspy
  target: ".bs-sidebar"
  offset: $(".navbar").outerHeight(true) + 10

$(window).on "load", ->
  $body.scrollspy "refresh"

hljs.initHighlightingOnLoad()
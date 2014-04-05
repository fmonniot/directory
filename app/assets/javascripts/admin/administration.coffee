#= require jquery.js
#= require jquery_ujs

#= require twitter/bootstrap

#= require jquery/metisMenu
#= require jquery/jquery.flot
#= require jquery/jquery.flot.pie
#= require jquery/jquery.flot.resize
#= require jquery/jquery.flot.tooltip.min

#= require moment

# require admin/app

#= require_self

# Initialize the accordion style menu
$ ->
  $('#side-menu').metisMenu()

# Loads the correct sidebar on window load
$ ->
  $(window).bind "load", ->
    console.log($(this).width())
    if ($(this).width() < 768)
      $('div.sidebar-collapse').addClass('collapse')
    else
      $('div.sidebar-collapse').removeClass('collapse')

# Collapses the sidebar on window resize
$ ->
  $(window).bind "resize", ->
    console.log($(this).width())
    if ($(this).width() < 768)
      $('div.sidebar-collapse').addClass 'collapse'
    else
      $('div.sidebar-collapse').removeClass 'collapse'
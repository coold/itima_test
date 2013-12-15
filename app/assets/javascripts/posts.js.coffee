# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
flashHide = ->
	if $('#notice').html()!=''
		$('#notice').html('')

ready = ->
	setTimeout flashHide, 5000

$(document).ready(ready)
$(document).on('page:load', ready)
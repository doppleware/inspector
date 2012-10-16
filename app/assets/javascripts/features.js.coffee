# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $("#features-search-field").keyup( -> 
  	$.get($("#features-search-form").attr("action"), $("#features-search-form").serialize(), null, "script"))
  
  $("#features-search-field").blur( ->   
  	history.pushState(null, document.title + $("#features-search-form").serialize() , 
  	#$("#features-search-form").attr("action") +# 
  	"?" + $("#features-search-form").serialize()))
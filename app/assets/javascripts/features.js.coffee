# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

inspector.features = new Object();

inspector.features.initialize = -> 	
	$("#features-search-field").keyup( -> 		
		$("#features-search-form").submit())

	$("#features-search-field").blur( -> 
  		history.pushState(null, document.title + $("#features-search-field").val(), 
  		$("#features-search-form").attr("action") + "?" + $("#features-search-form").serialize()))

	$("#features-search-form").submit( (e) -> 		
		$('.hero-pic').hide())


$(window).bind("popstate", ->		
	query = $.url().param('query')	
	unless query? 
		query = ""
	$("#features-search-field").val(query)
	if (query.length!=0)				
		$("#features-search-form").submit()
	else
		$('#feature_results').html(""))

$ -> inspector.features.initialize()
  
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

inspector.features = new Object();

inspector.features.registerLiveSearch = (searchForm) ->
	$('#features-search-field').livesearch(		
		searchCallback: -> inspector.features.pjaxUnsavedOnly(searchForm, true)    	    		
		queryDelay: 250
		innerText: "Examine features and scenarios"
		minimumSearchLength: 3)

inspector.features.pjaxUnsavedOnly = (form, no_push) ->
	url = form.attr("action") + "?" + form.serialize()	
	$.pjax container: '[data-pjax-container]', url: url, timeout: 3000
	return true

inspector.features.pushStateOnFocusOut = ->
	$("#features-search-field").blur((event) -> 				
		form = $(this).parents("form")		
		inspector.features.pjaxUnsavedOnly(form)
		return true)

inspector.features.overrideSearchFormSubmit = (searchForm) ->
	searchForm.submit( (e) -> 		
		e.preventDefault()
		$('.hero-pic').hide()		
		return false)	

inspector.features.pushTemporaryStateBeforeLeavingPage = (form) ->
	$('[data-pjax-container]').pjax(".feature-link")
	$('[data-pjax-container]').pjax(".topic-link")
	$('[data-pjax-container]').pjax(".tag-filter-box-close")
	$('[data-pjax-container]').pjax(".show-more a")

inspector.features.initialize = -> 	
		
	searchForm = $("#features-search-form")
				
	inspector.features.registerLiveSearch(searchForm)
	inspector.features.overrideSearchFormSubmit(searchForm)	
	inspector.features.pushTemporaryStateBeforeLeavingPage(searchForm)

inspector.features.handlePopState = ->	
	query = inspector.getParamFromUrl('query')		
	$("#features-search-field").val(query)

inspector.getParamFromUrl= (param) -> $.url().param('query')

$(window).bind("popstate", inspector.features.handlePopState)

$ -> inspector.features.initialize()  
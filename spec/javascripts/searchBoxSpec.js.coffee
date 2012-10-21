describe "search box", ->
	beforeEach -> 
		loadFixtures("first_visit_main_page.html")
		inspector.features.initialize()		

	describe "typing anything into it", ->
		beforeEach -> 		
			spyOn($, 'ajax').andCallFake((ajaxParams) -> ajaxParams.success())
			$("#features-search-field").val("Anything")
			$("#features-search-field").keyup()			

		it "should hide the welcome box", ->						
			expect($('#investigator-hero-unit').is(":visible")).toBeFalsy()	
		
		it "should query the server for the text typed in so far", ->
			expect($.ajax).toHaveBeenCalled()
			expect($.ajax.mostRecentCall.args[0].data[0].name).toEqual("query")
			expect($.ajax.mostRecentCall.args[0].data[0].value).toEqual("Anything")

	describe "when the search field contains text", ->		
		beforeEach -> $("#features-search-field").val("Anything")		
		
		describe "and it loses focus", ->
			it "should update the location to match the search query", ->
				$("#features-search-field").val("Anything")
				pushStateSpy = spyOn(window.history, 'pushState')
					.andCallFake((data, title, url) => expect(url).toEqual('/features?query=Anything'))
				$("#features-search-field").blur()

		describe "and the examine button is clicked", ->
			beforeEach -> 		
				spyOn($, 'ajax').andCallFake((ajaxParams) -> ajaxParams.success())				
				$("#features-search-form").submit()
			
			it "should hide the welcome box", -> 
				expect($('#investigator-hero-unit').is(":visible")).toBeFalsy()	

			it "should query the server for the text typed in so far", ->
				expect($.ajax).toHaveBeenCalled()
				expect($.ajax.mostRecentCall.args[0].data[0].name).toEqual("query")
				expect($.ajax.mostRecentCall.args[0].data[0].value).toEqual("Anything")



describe "push state pop handling", ->
	beforeEach -> 	
		loadFixtures("first_visit_main_page.html")
		inspector.features.initialize()	
		spyOn($, 'ajax').andCallFake((ajaxParams) -> ajaxParams.success())	
	
	describe "if the current url query param has a value", ->
		beforeEach -> spyOn(inspector, 'getParamFromUrl').andReturn("current")				
		
		it "should change the value of the search box to the current query", ->	
			inspector.features.handlePopState()	
			expect($("#features-search-field").val()).toEqual("current")

		it "should query the server with the current query param", ->	
			inspector.features.handlePopState()	
			expect($.ajax).toHaveBeenCalled()
			expect($.ajax.mostRecentCall.args[0].data[0].name).toEqual("query")
			expect($.ajax.mostRecentCall.args[0].data[0].value).toEqual("current")

	describe "if the current url query param is empty", ->
		beforeEach -> 
			spyOn(inspector, 'getParamFromUrl').andReturn("") 
			$("#features-search-field").val("blah")

		it "should clear the text in the search field", ->
			inspector.features.handlePopState()
			expect($("#features-search-field").val()).toEqual("")

		it "should not query the server", ->	
			inspector.features.handlePopState()	
			expect($.ajax).not.toHaveBeenCalled()
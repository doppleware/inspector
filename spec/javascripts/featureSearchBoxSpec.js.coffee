describe "Feature search box", ->
	describe "Searching for anything", ->
		it ("hides the welcome area on the main page"), ->
			loadFixtures("first_visit_main_page.html")			
			Inspector.hideWelcomeArea()	
			expect($('#investigator-hero-unit').is(":visible")).toBeFalsy()			
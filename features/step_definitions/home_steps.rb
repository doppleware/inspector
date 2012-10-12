Given /^I am on the main page$/ do
  visit '/'  
end

Then /^I should see the product logo$/ do
  page.should have_content "mystery"
end

Given /^I search for something$/ do
  within("#features-search-form") do
    fill_in 'features-search-field', :with => 'blah'    
    click_button 'Examine'
  end  
end

Then /^I should not see the product logo$/ do    
  invisible? '#investigator-hero-unit'
end

Then /^I should see the search results area$/ do
  page.should have_selector('.feature-area')  
end


def invisible? (elementId)
	wait_until { !find(elementId).visible? }
end
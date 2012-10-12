Feature: Searching features
    As a user
    I want to search for features
    So that I can understand them

Scenario: The product logo should be visible when I visit the page    
    Given I am on the main page   
    Then I should see the product logo    

@javascript
Scenario: When I search the product logo disappears and I see search results instead
    Given I am on the main page   
    And I search for something
    Then I should not see the product logo  
    And I should see the search results area      
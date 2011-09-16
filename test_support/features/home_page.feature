  Feature: Homepage
    I want the home page to reflect localizations properly
    
    Scenario: home page text
      When I am on the home page
      Then I should not see "override"
      And I should see "Hydrant"
      And I should see "Variations"
      And I should see "Video"
      And I should see "Search"


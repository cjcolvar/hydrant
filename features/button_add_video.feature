@create @split_button @add_asset
Feature: Button to Add Video
  In order to create Videos
  As a person with submit permissions
  I want to see a button for adding Videos
  
  Scenario: button to add videos on home page
    Given I am logged in as "archivist1@example.com"
    When I am on the home page
    When I follow "Add a Video" 
    Then I should see "Created a Video with pid "

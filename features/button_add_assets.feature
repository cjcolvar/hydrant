@create @split_button @add_asset
Feature: Create Asset Split Button
  In order to create new Assets
  As an editor 
  I want to see a button that will let me create a new Video
  
  Scenario: Editor views the search results page and sees the buttons to add assets
    Given I am logged in as "archivist1@example.com" 
    Given I am on the base search page
#    Then I should see "Add a Basic MODS Asset" within "a.create_asset" 
#    Then I should see "Add an Image"   
    Then I should see "Add a Video" 
    # Then I should see a link to add a "mods_asset" asset 
    # Then I should see a link to add a "generic_image" asset 
    # Then I should see a link to add a "generic_content" asset
  
  # Need to build this out more
  Scenario: Non-editor views the search results page and sees the buttons to add assets which link to login then create an asset
   Given I am on the base search page
#   Then I should see "Add a Basic MODS Asset" within "a.create_asset" 
#   Then I should see "Add an Image"
#   Then I should see "Add Generic Content" 
   Then I should see "Add a Video" 

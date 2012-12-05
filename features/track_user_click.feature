Feature: Track user clicks to give better recommendations in the future

  As a theatre-goer and frequent visitor to the site,
  So that I can discover new shows,
  I want to get recommendations based on my past activity on the website

Background: shows have been added

  Given the database has been setup with smalltable.xml
  And I am on the home page
  And the date is set to 2012
  And I am already logged in

Scenario: When I buy a ticket for a show, then I should see an interest for it with click value 1 in the db (assuming it was not in db already)
  Given that I am on the show page with id "1"
  And I follow "1_buy"
  Then I should have a click value of 1 for show_id 1

Scenario: When I view more information for a show, then I should see an interest for it with a click value of 0 in the db
  Given I am on the home page
  And I follow "all culture"
  And I follow "2_more_info"
  Then I should have a click value of 0 for show_id 2

Scenario: I should be able to update a change for an interest that already exists
  Given there is an entry with show_id 2 with click value 0 
  And that I am on the show page with id "2"
  And I follow "2_buy"
  Then I should have a click value of 1 for show_id 2

Scenario: I should not be able to change a click to 0 if it has a value of 1
  Given there is an entry with show_id 2 with click value 1
  And I am on the home page
  And I follow "all culture"
  And I follow "2_more_info"
  Then I should have a click value of 1 for show_id 2

Scenario: I should not be able to update a change if something has a higher existing value
  Given there is an entry with show_id 3 with click value 2
  And that I am on the show page with id "3"
  And I follow "3_buy"
  Then I should have a click value of 2 for show_id 3

Scenario: I should not be able to change a click to 0 if it has a value of 2
  Given there is an entry with show_id 3 with click value 2
  And I am on the home page
  And I follow "all culture"
  And I follow "3_more_info"
  Then I should have a click value of 2 for show_id 3


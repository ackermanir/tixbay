Feature: Favorite shows from show page

  As a frequent visitor to the site,
  So that I can revisit show listings that I find interesting,
  I want to favorite show listings that I like.

Background: shows have been added to database

  Given the database has been setup from xml
  And the date is set to 2012
	And I am already logged in
	And I am on the home page 

@javascript
Scenario: No option to favorite if not logged in
	And I follow "Log Out"
	And I am on the home page 
	And I follow "2_more_info"
	Then I should not see "Favorite"

@javascript
Scenario: Option to favorite show from show page, Remembers if navigate away
	And I follow "2_more_info"
  Then I should see "Favorite"
	And I should not see "Favorited"
	And I press "Favorite"
	Then I should see "Favorited"
	And I am on the home page
 	And I follow "2_more_info"
	Then I should see "Favorited"

@javascript
Scenario: Able to unfavorite a show
	And I follow "2_more_info"
	Then I should not see "Favorited"
	And I press "Favorite"
	Then I should see "Favorited"
	And I press "Favorited"
	Then I should not see "Favorited"

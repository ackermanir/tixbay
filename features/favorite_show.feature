@wip
Feature: Favorite shows from show page

  As a frequent visitor to the site,
  So that I can revisit show listings that I find interesting,
  I want to favorite show listings that I like.

Background: shows have been added to database

  Given the database has been setup from xml
  And I am on the home page
  And the date is set to 2012
 
Scenario: Option fo favorite show from show page
  Given I am signed in as musicaluser
	And I follow "BATS Improv Comedy"
  Then I should see "Like this show"

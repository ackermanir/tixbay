Feature: sign up by creating a new user account

  As a frequent visitor to the site
  So that I can keep track of my activity
  I want to be able to create an user account

Scenario: sign up for a new account
  When I am on the home page
  And I press "sign up"
  Then I should be on the "Create New Profile Page"

Scenario: create a new account
  When I am on the "Create New Profile Page"
  And I fill in "field name" with "field option"
  And I press "Create"
  Then a new entry should be in the "User"
  And I should be on the home page
  And I should see my recommendations



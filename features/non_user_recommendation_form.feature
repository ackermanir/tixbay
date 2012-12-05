Feature: As a non-user, I want to be able to also use the recommendation feature

  As a non-user,
  so that I can get better listings
  I want to use the form to get a recommended set of listings

Background:
  
  Given the database has been setup with smalltable.xml
  And I am on the home page
  And the date is set to 2012

Scenario: Fill out the form to get a recommended listings
  
  Given I am on the home page
  And I follow "recommended"
  And I follow "Recommend without sign up"
  Then I should see "Custom Recommendations Form"

  When I check "Jazz"
  And I fill in "recommendation_location_zip_code" with "94720"
  And I press "Submit"

  Then I should see "recommended"

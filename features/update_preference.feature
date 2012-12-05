Feature: Update Preference Form

  As a frequent visitor to the site,
  So that I can update my preferences,
  I want to be able to make changes to my preferences

Background: shows have been added to database

  Given the database has been setup with smalltable.xml
  And I am on the home page
  And the date is set to 2012
  And I am already logged in

Scenario: Should be able to update my preferences by checking everything
  Given I am on the home page
  And I follow "recommended"

  When I check "Comedy"
  And I check "Drama"
  And I check "Tragedy"
  And I check "Musical"
  And I check "Solo"
  And I check "Jazz"
  And I check "Cabaret"
  And I check "Classical"
  And I check "Indie-Rock"
  And I check "Animated"
  And I check "Documentary"
  And I check "Silent"
  And I check "Festival"
  And I check "Short"
  And I check "Drive-In"
  And I check "Classic"
  And I check "Sci-Fi"
  And I check "Premiere"
  And I check "Family"
  And I check "Theatre"
  And I check "Performing Arts"
  And I check "Popular Music"
  And I check "Jazz"
  And I check "Classical"
  And I check "Classic Rock"
  And I check "Film"
  And I check "Comedy"
  And I check "Family"
  And I check "Food & Social"
  And I fill in "recommendation_location_zip_code" with "94720"
  And I press "Submit"
  Then I should see "recommended"
  And I should see "Edit Recommendation Preferences"

  When I follow "Edit Recommendation Preferences"

  Then the "Comedy" checkbox should be checked
  And the "Drama" checkbox should be checked
  And the "Tragedy" checkbox should be checked
  And the "Musical" checkbox should be checked
  And the "Solo" checkbox should be checked
  And the "Jazz" checkbox should be checked
  And the "Cabaret" checkbox should be checked
  And the "Classical" checkbox should be checked
  And the "Indie-Rock" checkbox should be checked
  And the "Animated" checkbox should be checked
  And the "Documentary" checkbox should be checked
  And the "Silent" checkbox should be checked
  And the "Festival" checkbox should be checked
  And the "Short" checkbox should be checked
  And the "Drive-In" checkbox should be checked
  And the "Classic" checkbox should be checked
  And the "Sci-Fi" checkbox should be checked
  And the "Premiere" checkbox should be checked
  And the "Family" checkbox should be checked




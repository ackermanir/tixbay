Feature: Recommendations Based On Form

Background: database
    Given the database has been setup from xml

@wip
Scenario: link to recommendations form
    Given I am on the home page
    And I follow "custom"
    Then I should be on the recommendations form page

@wip
Scenario: get recommendations by one genre
    Given I am on the recommendations form page
    When I check "recommendation_category_film"
    And I press "Submit"
    Then I should see "BATS Improv Comedy"

@wip
Scenario: get recommendations by multiple genres
   Given I am on the recommendations form page
   When I check "recommendation_category_film"
   And I check "recommendation_category_theater"
   And I press "Submit"
   Then I should see "BATS Improv Comedy"
   And I should see "Erickson Theatre"

@wip
Scenario: get recommendations by location
  Given I am on the recommendations form page
  When I check "recommendation_category_theatre"
  When I check "recommendation_category_film"
  And I fill in "recommendation_location_city" with "San Francisco"
  And I fill in "recommendation_location_region" with "CA"
  And I press "Submit"
  Then I should see "BATS Improv Comedy"
  And I should not see "Kristin Chenoweth"

@wip
Scenario: get recommendations by date
  Given I am on the recommendations form page
  And I check "recommendation_category_theater"
  And I check "recommendation_category_film"
  And I check "recommendation_category_classical"
  When I fill in "recommendation_startdate_month" with "10"
  And I fill in "recommendation_startdate_day" with "10"
  And I fill in "recommendation_startdate_year" with "2012"
  And I fill in "recommendation_enddate_month" with "10"
  And I fill in "recommendation_enddate_day" with "30"
  And I fill in "recommendation_enddate_year" with "2012"
  And I press "Submit"
  Then I should see "BATS Improv Comedy"
  And I should not see "Kristin Chenoweth"
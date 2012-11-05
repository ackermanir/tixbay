Feature: Recommendations Based On Form

Background: database
    Given the database has been setup from xml

Scenario: link to recommendations form
    Given I am on the home page
    And I follow "custom"
    Then I should be on the recommendations form page

Scenario: get recommendations by one category
    Given I am on the recommendations form page
    When I check "recommendation_category_film"
    When I fill in "recommendation_startdate_month" with "10"
    And I fill in "recommendation_startdate_day" with "10"
    And I fill in "recommendation_startdate_year" with "2010"
    And I fill in "recommendation_enddate_month" with "10"
    And I fill in "recommendation_enddate_day" with "30"
    And I fill in "recommendation_enddate_year" with "2014"
    And I press "Submit"
    Then I should see "BATS Improv Comedy"
    Then I should not see "Kristin Chenoweth"

Scenario: get recommendations by multiple categories
   Given I am on the recommendations form page
   When I check "recommendation_category_film"
   And I check "recommendation_category_theater"
   When I fill in "recommendation_startdate_month" with "10"
   And I fill in "recommendation_startdate_day" with "10"
   And I fill in "recommendation_startdate_year" with "2010"
   And I fill in "recommendation_enddate_month" with "10"
   And I fill in "recommendation_enddate_day" with "30"
   And I fill in "recommendation_enddate_year" with "2014"
   And I press "Submit"
   Then I should see "BATS Improv Comedy"
   And I should see "Kristin Chenoweth"

Scenario: get recommendations by location and distance
  Given I am on the recommendations form page
  When I check "recommendation_category_theater"
  When I check "recommendation_category_film"
  When I fill in "recommendation_startdate_month" with "10"
  And I fill in "recommendation_startdate_day" with "10"
  And I fill in "recommendation_startdate_year" with "2010"
  And I fill in "recommendation_enddate_month" with "10"
  And I fill in "recommendation_enddate_day" with "30"
  And I fill in "recommendation_enddate_year" with "2014"
  When I fill in "recommendation_location_zip_code" with "94123"
  And I press "Submit"
  Then I should see "BATS Improv Comedy"
  And I should not see "Kristin Chenoweth"


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
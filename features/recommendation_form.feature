Feature: Recommendations Based On Form

Background: database
    Given the database has been setup from xml

Scenario: link to recommendations form
    Given I am on the home page
    And I follow "custom"
    Then I should be on the recommendations form page

Scenario: get recommendations by genre
    Given I am on the recommendations form page
    When I check "recommendation_category_film"
    And I press "Submit"
    Then I should see 

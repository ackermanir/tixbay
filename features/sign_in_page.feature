@wip
Feature: Login and Signup Page
    
    As a tix bay area user
    So that I can login to the site or sign up for an account
    I want to see a page with personal recommendations

Background: users table works on backend

    Given the database has been setup from xml
    And I am on the home page

Scenario: sign up for a new account
    Then I follow "Custom"
    Then I should see the "custom" page
    And I click "sign up"
    Then I should see the "create account" page
    When I fill in "username" with "cong"
    And I fill in "password" with "chen"
    And I fill in "confirm password" with "chen"
    And I press "Submit"
    Then I should see the recommendation form page

Scenario: login with an existing tixbay account
    Then I follow "Custom"
    Then I should see the "custom" page
    And I click "login"
    Then I should see the "login" page
    When I fill in "username" with "cong"
    And I fill in "password" with "chen"
    And I press "Submit"
    Then I should see the dashboard page

Scenario: logout
    Given I am logged in
    Then I follow "logout"
    Then I should be on the home page
    When I follow "Custom"
    Then I should see the "custom" page
    And I should not see "dashboard"

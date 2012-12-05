Feature: Login and Signup Page
    
    As a tix bay area user
    So that I can login to the site or sign up for an account
    I want to see a page with personal recommendations

Background: users table works on backend

    Given the database has been setup from xml
    And I am on the home page

Scenario: sign up for a new account
    Then I follow "recommended"
    Then I should be on the sign in page
    And I follow "Sign up"
    Then I should be on the sign up page
    When I fill in "user_first_name" with "Obama"
    When I fill in "user_last_name" with "Llama"
    When I fill in "user_email" with "congchen@gg.com"
    And I fill in "user_password" with "congchen"
    And I fill in "user_password_confirmation" with "congchen"
    And I press "Sign Up"
    Then I should be on the recommendations form page

Scenario: login with an existing tixbay account
    Given I already signed up 
    Then I follow "recommended"
    Then I should be on the sign in page
    When I fill in "user_email" with "congchen@gg.com"
    And I fill in "user_password" with "congchen"
    And I press "Log In"
    Then I should be on the recommendations form page 

Scenario: login directs to logged in dashboard if form filled out before
   Given I already signed up
   And I already filled out the recommendations form
   Then I follow "recommended"
   When I fill in "user_email" with "congchen@gg.com"
   And I fill in "user_password" with "congchen"
   And I press "Log In"
   Then I should be on the logged in dashboard

Scenario: logout
    Given I am already logged in
    Then I go to the home page
    Then I follow "Log Out"
    Then I should be on the home page
    Then I should see "log in"
    When I follow "recommended"
    Then I should be on the sign in page 
    And I should not see "log out" 

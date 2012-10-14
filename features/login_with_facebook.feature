Feature: login with Facebook

  As a web user
  So that I can sign in easily
  I want to be able to sign in to Theatre Bay Area using my Facebook account

Scenario: logging in 
  When I am on the home page
  And I press "Log In"
  Then I should be on the "Facebook Sign-in Page"

Scenario: logging with Facebook information
  When I am on the "Facebook Sign-in Page"
  And I login with my Facebook information
  Then I should be on the home page
  And I should be logged in

Scenario: logging in with Facebook when already logged into Facebook and information is cached
  When I am on the home page
  And I already have Facebook saved in my cache
  And I press "Log In"
  Then I should be on the home page
  And I should be logged in





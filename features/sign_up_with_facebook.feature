Feature: sign up through Facebook

  As a web user
  So that I can create an account as quickly as possible
  I want to be able to sign up to Theatre Bay Area using my Facebook account

Scenario: sign up for a new account
  When I am on the home page
  And I press "sign up"
  Then I should be on the "Create New Profile Page"

Scenario: signing in with Facebook
  When I am on the "Create New Profile Page"
  And I press "Sign up with Facebook"
  Then I should be directed to a "Facebook Sign-in Page"

Scenario: creating a new account
  When I am on the "Facebook Sign-in Page"
  And I login with my Facebook information
  Then a new entry should be in the "User"
  And I should be on the home page





Feature: Have a button to go back to the top of the page show up if I am past the beginning

  As a tix bay area user
  So that I can easily navigate back to the top
  I want to have a button I can click to back up to the top of the page

Scenario: When I am at the top of the page, I should not see the button
  Given the database has been setup with similarshows.xml
  Then I should not see "Back to Top"

Scenario: When I am at the bottom of the page, I should see the button
  Given the database has been setup with backtotop.xml
  And I scroll to the bottom of the page
  Then I should see "Back to Top"

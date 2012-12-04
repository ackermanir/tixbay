Feature: Track user clicks to give better recommendations in the future

  As a theatre-goer and frequent visitor to the site,
  So that I can discover new shows,
  I want to get recommendations based on my past activity on the website

Background: shows have been added

  Given the database has been setup with similarshows.xml
  And I am on the home page
  And the date is set to 2012

Scenario: I buy a ticket for a music show, then I should see an interest for in the db
  Given I am signed in as frequentUser
  And I follow "music"
  And I follow "Yoshi's Jazz Club Oakland"
  And I follow "Purchase Tickets"
  Then I should have a count for "Yoshi's Jazz Club Oakland"

  When I follow recommended
  Then I should see music shows



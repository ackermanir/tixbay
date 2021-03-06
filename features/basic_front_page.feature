Feature: Basic Front Page

  As a tix bay area user
  So that I can effectively nagivate the website to view shows and buy tickets
  I want to see a home page with relevant links and information

Background: shows have been added to database

  Given the database has been setup from xml
  And the date is set to 2012
  And I am on the home page

Scenario: view new possible shows
  Then I should see "Avenue Q"
  And I should see "Erickson Theatre"

Scenario: buy a ticket to a show
  And I follow "Purchase Tickets"
  Then I should be redirected to Goldstar

Scenario: press "tix" logo redirect
  And I press the tix logo
  Then I should be on the home page

Scenario: press "Theatre Bay Area" redirect
  And I follow "Theatre Bay Area"
  Then I should be redirected to the Theatre Bay Area page

Scenario: filter "theatre" shows
  And I press the "theatre" tab
  Then I should be on the theatre page
  And I should see "theatre" shows

Scenario: filter "music" shows
  And I press the "music" tab
  Then I should be on the music page
  And I should see "music" shows

Scenario: filter "film" shows
  And I press the "film" tab
  Then I should be on the film page
  And I should see "film" shows

Scenario: filter "all culture" shows
  And I press the "all culture" tab
  Then I should be on the all culture page
  And I should see "film" shows
  And I should see "music" shows
  And I should see "theatre" shows

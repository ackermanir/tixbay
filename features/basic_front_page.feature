Feature: Basic Front Page

  As a tix bay area user
  So that I can effectively nagivate the website to view shows and buy tickets
  I want to see a home page with relevant links and information

Scenario: view new possible shows
  When I am on the home page
  Then I should see shows

Scenario: buy a ticket to a show
  When I am on the home page
  And I see a potential show I like
  And I press "purchase tickets"
  Then I should be redirected to Goldstar

Scenario: press "tix" logo redirect
  When I am on the home page
  And I press the tix logo
  Then I should be on the home page

Scenario: press "Theatre Bay Area" redirect
  When I am on the home page
  And I press the "Theatre Bay Area" in the "About Me" section
  Then I should be on the "Theatre Bay Area" page

Scenario: filter "theatre & dance" shows
  When I am on the home page
  And I press the "theatre & dance" tab
  Then I should be on the home page
  And I should see "theatre & dance" shows

Scenario: filter "music" shows
  When I am on the home page
  And I press the "music" tab
  Then I should be on the home page
  And I should see "music" shows

Scenario: filter "film" shows
  When I am on the home page
  And I press the "film" tab
  Then I should be on the home page
  And I should see "film" shows

Scenario: filter "all culture" shows
  When I am on the home page
  And I press the "all culture" tab
  Then I should be on the home page
  And I should see "all" shows

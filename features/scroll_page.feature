Feature: Faster Loading with Scroll

  As a tix bay area user
  So that I can easily navigate the website and the page loads more quickly
  I want to load and view only a certain number of shows on the home page at one time

Background: shows have been added to the database

  Given the database has been setup from xml
  And I am on the home page
  And the date is set to 2012

Scenario: should show only 15 shows at first
  Given we paginate after 15 shows 
  Then I should only see 15 shows

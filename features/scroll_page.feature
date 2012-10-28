Feature: Faster Loading with Scroll

  As a tix bay area user
  So that I can easily navigate the website and the page loads more quickly
  I want to load and view only a certain number of shows on the home page at one time

Background: shows have been added to the database

  Given the database has been setup from xml
  And I am on the home page

Scenario: show only 10 listings
  Then I should see only 10 listings

Scenario: show more listings when scroll to the bottom
  And my cursor hovers to the bottom of the page
  Then I should see 20 listings

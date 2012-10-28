Feature: Faster Loading with Scroll

  As a tix bay area user
  So that I can easily navigate the website and the page loads more quickly
  I want to load and view only a certain number of shows on the home page at one time

Background: shows have been added to the database

  Given the database has been setup from xml
  And I am on the home page

Scenario: should show only 10 listings at first
  Then I should only see 10 listings

Scenario: should add 10 more listings when you scroll down
  And I hover over the bottom of the page
  Then I should see 10 more listings

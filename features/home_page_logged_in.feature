Feature: home page logged in

	As a returning tix bay area user
	So that I can receive custom recommendations based on past usage
	I want to see helpful home page information when I am logged in

Background:
	Given I am on the home page
	And I am logged in

Scenario: log out and welcome back
	Then I should see "log out"
	And I should see "Welcome back"

Scenario: recommended lists
	Then I should see "Recommended for you"
	And I should see "recently viewed"
	And I should see "starred"

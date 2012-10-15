Feature: home page (not logged in)

	As a tix bay area user
	So that I can effectively navigate the website to view shows and buy tickets
	I want to see a home page with relevant links and information

Background:
	Given I am on the home page
	And I am not logged in

Scenario: view home page
	Then I should see "Log In"
	And I should see "Sign Up"

Scenario: genre tabs
	Then I should see "theater & dance"
	And I should see "music"
	And I should see "film"
	And I should see "all culture"
	And I should see "custom"

Scenario: custom recommendation banner
	Then I should see "custom recommendation"
	And I should see "find shows"
	And I should see "click here" 

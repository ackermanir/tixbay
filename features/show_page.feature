Feature: All the displayed shows should be able to redirect to another page that shows similiar shows

  As a user
  So that I can get find similar shows to that of the ones I like
  I want to be able to click a show and see what other similar shows are available

Background: Set the testing database with values
  Given the database has been setup with similarshows.xml
  And the date is set to 2012
  And I am on the home page

Scenario: Click on a show to redirect to the show page for Cirque de Soleil
  When I follow "2_more_info"
  Then I should be on the show page with id "2"

  Then I should see "Cirque du Soleil: Saltimbanco"
  And I should see ""Cirque du Soleil" presents "Saltimbanco", an exploration of the urban experience in all its forms"

  And I should see "The Boston Babydolls: "The Wrathskellar""
  And I should see "The Wrathskellar" returns for 2012, eschewing the Boston Babydolls' usual"
 
Scenario: When I click on a show in the similarshow table, I should be redirected to a new similarshow page for that show
  Given that I am on the show page with id "2"
  When I follow "6_more_info"
  Then I should be on the show page with id "6"
  And I should see "The Boston Babydolls: "The Wrathskellar""
  And I should see "The Wrathskellar" returns for 2012, eschewing the Boston Babydolls' usual"

Scenario: Being on a show page, I should still be able to purchase tickets
  Given that I am on the show page with id "2"
  When I follow "2_buy"
  Then I should be redirected to Goldstar

Scenario: Being on a show page that has no similar shows, I None should be displayed
  Given that I am on the show page with id "3"
  Then I should see "No Similar Shows Found"

Feature: All the displayed shows should be able to redirect to another page that shows similiar shows

  As a user
  So that I can get find similar shows to that of the ones I like
  I want to be able to click a show and see what other similar shows are available

Background: Set the testing database with values
  Given the database has been setup with similarshows.xml
  And I am on the home page
  And the date is set to 2012

Scenario: Click on a show to redirect to the show page for Cirque de Soleil
  # Update to pick link under theater & dance for Cirque de Soleil
  #This link hasn't been set up yet
  When I follow ""Cirque du Soleil: Saltimbanco""
  #for "Cirque de Soleil"
  Then I should be on the show page with id "2"

  #After clicking the similar shows page link, I should see the show itself and more information
  Then I should see "Cirque du Soleil: Saltimbanco"
  #Random sentence from the summary
  And I should see ""Cirque du Soleil" presents "Saltimbanco", an exploration of the urban experience in all its forms"

  #A similar Show
  And I should see "The Boston Babydolls: "The Wrathskellar""
  And I should see "The Wrathskellar" returns for 2012, eschewing the Boston Babydolls' usual"
 
Scenario: When I click on a show in the similarshow table, I should be redirected to a new similarshow page for that show
  Given that I am on the show page with id "2"
  When I follow "The Boston Babydolls: "The Wrathskellar""
  Then I should be on the show page with id "6"
  And I should see "The Boston Babydolls: "The Wrathskellar""
  And I should see "The Wrathskellar" returns for 2012, eschewing the Boston Babydolls' usual"

Scenario: Being on a show page, I should still be able to purchase tickets
  Given that I am on the show page with id "2"
  When I follow "Purchase Tickets"
  Then I should be redirected to Goldstar

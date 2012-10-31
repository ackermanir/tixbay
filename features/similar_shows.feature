Feature: All the displayed shows should be able to redirect to another page that shows similiar shows

  As a user
  So that I can get find similar shows to that of the ones I like
  I want to be able to click a show and see what other similar shows are available

Background: Set the testing database with values
  Given the database has been setup with similarshows.xml
  And I am on the home page

@wip
Scenario: Click on a show to redirect to the similarshow for Cirque de Soleil
  # Update to pick link under theater & dance for Cirque de Soleil
  #This link hasn't been set up yet
  When I follow "Similar Shows"
  #for "Cirque de Soleil"
  Then I should be on "similar shows page"

  #After clicking the similar shows page link, I should see the show itself and more information
  Then I should see "Cirque du Soleili: Saltimbanco"
  #Random sentence from the summary
  And I should see "his high-energy acrobatic spectacle is inspired by the pulsing energy of the metropolis and its colorful inhabitants"

  #A similar Show
  And I should see "Memphis"
  And I should see "he man who first spun the music of black and white musicians together on American radio"
 
@wip
Scenario: When I click on a show in the similarshow table, I should be redirected to a new similarshow page for that show
  Given that I am on the similar shows page with id "2"
  #At the moment, this link hasn't been set up
  #for "Memphis"
  When I follow "Similar Shows" 
  Then I should be on similar shows page with id "5"
  And I should see "Memphis"
  And I should see "the man who first spun the music of black and white musicians together on American radio"

@wip
Scenario: Being on a similarshow page, I should still be able to purchase tickets
  Given that I am on the similar shows page with id "2"
  When I press "Purchase Ticket"
  Then I should be redirected to Goldstar

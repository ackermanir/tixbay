Feature: All the displayed shows should be able to redirect to another page that shows similiar shows

  As a user,
  So that I can get find similar shows to that of the ones I like
  I want to be able to click a show and see what other similar shows are available

Background:
  Given that I am on the home page

Scenario: Click on a show to redirect to the similar_show page
  # Update to pick link under theater & dance for Cirque de Soleil
  When I follow "Similar Shows" 
  Then I should be on "Similar Shows Page"

  #After clicking the similar shows page link, I should see the show itself and more information
  Then I should see "Cirque du Soleili: Saltimbanco"
  #Random sentence from the summary
  And I should see "his high-energy acrobatic spectacle is inspired by the pulsing energy of the metropolis and its colorful inhabitants."


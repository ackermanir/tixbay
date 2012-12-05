Feature: When displaying the summaries to shows, I want the text to be truncated so I can show less or more

  As a user
  So that I see less text and read the ones I'm interested in
  I want to be able to click more and less to show or less text

@javascript
Scenario: By clicking more, I should be able to see more text
  Given the database has been setup with singleentry.xml
  And I am on the home page
  And the date is set to 2012
  Then I should see "So it's only fitting that when San Francisco Ballet Artistic Director and Principal Choreographer Helgi Tomasson set out"

  #After clicking the similar shows page link, I should see the show itself and more information
  When I follow "more"
  Then I should see "of course Tchaikovsky's beautiful score performed live by the world-class San Francisco Ballet Orchestra"

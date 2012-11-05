Feature: When displaying the summaires to shows, I want the text to be truncated so I can show less or more

  As a user
  So that I see less text and read the ones I'm interested in
  I want to be able to click more and less to show or less text

@javascript
Scenario: By clicking more, I should be able to see more text
  Given the database has been setup with similarshows.xml
  And that I am on the show page with id "5"
  And the date is set to 2012
  Then I should see "Inspired by actual events, rocking musical "Memphis" immortalizes '50s DJ Huey Calhoun"

  #After clicking the similar shows page link, I should see the show itself and more information
  When I follow "more"
  Then I should see "This nationally touring hit is directed by Tony nominee Christopher Ashley"

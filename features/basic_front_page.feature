Feature: Basic Front Page

  As a tix bay area user
  So that I can effectively nagivate the website to view shows and buy tickets
  I want to see a home page with relevant links and information

Background: shows have been added to database

  Given the following shows exist:
    | title                   | image_url      | summary       | link                       | id      |     
    | The Greatest Show       | image.jpg      | fake summary  | http://www.goldstar.com/   |  1      |
    | Another Show            | image.jpg      | fake summary  | http://www.goldstar.com/   |  2      |
    | Lala Show               | image.jpg      | fake summary  | http://www.goldstar.com/   |  3      |
    | What Show               | image.jpg      | fake summary  | http://www.goldstar.com/   |  4      |

  Given the following categories exist:
    | name                    | id  | 
    | Theater                 | 1   | 
    | Jazz                    | 2   | 
    | Film                    | 3   | 

  And there are category and show associations
  And I am on the home page

Scenario: view new possible shows
  Then I should see "The Greatest Show"
  And I should see "Another Show"

Scenario: buy a ticket to a show
  And I follow "Purchase Tickets"
  Then I should be redirected to Goldstar

Scenario: press "tix" logo redirect
  And I press the tix logo
  Then I should be on the home page

Scenario: press "Theatre Bay Area" redirect
  And I follow "Theatre Bay Area"
  Then I should be redirected to the Theatre Bay Area page

Scenario: filter "theater" shows
  And I press the "theater" tab
  Then I should be on the home page
  And I should see "theater" shows

Scenario: filter "music" shows
  And I press the "music" tab
  Then I should be on the music page
  And I should see "jazz" shows

Scenario: filter "film" shows
  And I press the "film" tab
  Then I should be on the film page
  And I should see "film" shows

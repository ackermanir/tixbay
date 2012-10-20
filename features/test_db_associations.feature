Feature: Test DB Associations
  As a system admin
  In order to store and use my data appropriately
  I want to have tables set up correctly according to my schema

  Background:
    Given the information in the table Show:
    | id | title       | event_id | summary            | 
    | 1  | Van Helsing | 1        | Vampire Killer Man |

    And the information in the table Category:
    | id | name    |
    | 1  | Theater | 

    And the information in the table Showtime:
    | id | date_id | date_time      |
    | 1  | 5       | 2012/10/17 3pm |

    And the information in the table Venue:
    | id | name           |
    | 2  | Greek Theather |

  Scenario: Given the information for a show, I want to see the category, showtime, and venue corresponding to it
    Given I have an obj that points to the first entry in Show
    When I call obj.Category
    Then I should get "






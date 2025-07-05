Feature: Mark offer as favorite
  
  Background:
    Given I am logged in as a user
    And the user "otheruser@test.com" create an offer
    And I am on 'the offers screen'

  Scenario: US55.1 Mark another user's offer as favorite
    When I click the Fav button of an offer
    Then the offer is added to my favorites
    And a notification "Offer added to favorite list successfully" is shown

  Scenario: US55.2 Cannot favorite my own offer
    When I click the Fav button of an offer that is mine
    Then a notification "Can't Fav your own offers" is shown

  Scenario: US55.3 Clicking Fav button again does nothing
    Given the offer "React dev" is available
    And I already add the offer "React dev" to my favorites
    When I click the Fav button of the offer "React dev"
    Then a notification "This offer is already in your favorite list" is shown

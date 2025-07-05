@billing
Feature: non commercial organization Billing Report

  Background:
    Given a user "pepe@unicef.org" with "org" subscription

  Scenario: c1 - non commercial subscription with no offers
    Given 0 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@unicef.org" is 0.0
    And the total active offers are 0

  Scenario: c2 - non commercial subscription with two offers
    Given 2 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@unicef.org" is 0.0
    And the total active offers are 2


  Scenario: c3 - non commercial subscription with 8 offers should only activate 7
    Given another user with "org" susbcription
    When I am logged in
    When I create 8 offers
    And I activate 8 offers
    When I get the billing report
    Then the total active offers are 7
    And the last offer should not be active



  @wip
  Scenario: c4 - user with non @org email cannot have Org subscription
  When I am logged in
  And I try to get Org subscription
  Then I should see a message "You cannot have an Org subscription with a non @org email" 
  And I should not be able to get Org subscription

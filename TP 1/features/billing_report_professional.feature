@billing @wip
Feature: Professional Billing Report

  Scenario: p1 - professional subscription with no offers
    Given a user "pepe@pepito.com" with "professional" subscription
    And 0 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 30.0
    And the total active offers are 0

  Scenario: p2 - professional subscription with one offers
    Given a user "pepe@pepito.com" with "professional" subscription
    And 1 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 30.
    And the total active offers are 1

  Scenario: p3 - professional subscription with 7 offers
    Given a user "pepe@pepito.com" with "professional" subscription
    And 7 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 44.0
    And the total active offers are 7

  Scenario: p4 - professional subscription with 5 offers
    Given a user "pepe@pepito.com" with "professional" subscription
    And 5 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 30.0
    And the total active offers are 5
@billing
Feature: Billing Report

  Scenario: b1 - billing report when no active offers
    Given there are no offers at all
    When I get the billing report
    Then the total active offers is 0
    And the total amount is 0.0

  Scenario: US-X.1 - One user with on-demand subscription
    Given a user "pepe@pepito.com" with "on-demand" subscription
    When I get the billing report
    Then the subscription of "pepe@pepito.com" is "on-demand"

  Scenario: US-X.2 - One user with no comercial subscription
    Given a user "pepe@unicef.org" with "org" subscription
    When I get the billing report
    Then the subscription of "pepe@unicef.org" is "org"


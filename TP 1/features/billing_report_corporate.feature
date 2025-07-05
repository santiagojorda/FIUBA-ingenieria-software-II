@billing @wip
Feature: Corporate Billing Report

  Background:
    Given a user "pepe@pepito.com" with "corporate" subscription

  Scenario: c1 - corporate subscription with no offers
    Given 0 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 80.0
    And the total active offers are 0

  Scenario: c2 - corporate subscription for two users with no offers
    Given 0 active offers
    And another user "maria@maria.com" with "corporate" susbcription
    And 0 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 80.0
    And the amount to pay for the user "maria@maria.com" is 80.0
    And the total amount is 160.0
    And the total active offers are 0

  Scenario: c3 - corporate subscription with 10 offers
    Given 10 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 80.0
    And the total active offers are 10

  Scenario: c4 - corporate subscription with two user with 5 offers each
    Given 5 active offers
    And another user "maria@maria.com" with "corporative" susbcription
    And 5 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 80.0
    And the amount to pay for the user "maria@maria.com" is 80.0
    And the total amount is 160.0
    And the total active offers are 10

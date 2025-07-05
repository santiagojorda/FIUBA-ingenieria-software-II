@billing
Feature: On Demand Billing Report

  Background:
    Given a user "pepe@pepito.com" with "on-demand" subscription

  Scenario: on1 - One user with on-demand subscription with no offers
    Given 0 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 0.0


  Scenario: on2 - One user with on-demand subscription with one offer
    Given the user "pepe@pepito.com" has 1 active offers
    When I get the billing report
    Then the amount to pay for the user "pepe@pepito.com" is 10.0

  Scenario: on3 - One user with on-demand with 3 active offers and 2 inactive offers
    Given 3 active offers
    And 2 inactive offers
    When I get the billing report
    Then the billing for this user is 30.0

  Scenario: on4 - Two users with on-demand subscription with two offers each
    Given the user "pepe@pepito.com"
    And 2 active offers
    And another user with "on-demand" susbcription
    And 2 active offers
    When I get the billing report
    Then the total amount is 40.0
    And the total active offers are 4

  Scenario: on5 - Two users with on-demand subscription without offers
    Given the user "pepe@pepito.com"
    And 0 active offers
    And another user "maria@maria.com" with "on-demand" susbcription
    And 0 active offers
    When I get the billing report
    Then the total amount is 0.0
    And the total active offers are 0

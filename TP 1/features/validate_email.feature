Feature: Postulation email validation

  Background:
    Given I am on 'the offers screen' with a active offer
    And I apply to an Offer


  Scenario: US5.1 Valid email
    When I enter "juan@gmail.com" as an email for applying
    And I click the "Apply" button
    And a notification "Contact information sent." is shown


  Scenario: US5.2 Valid org email
    When I enter "uba@gmail.org" as an email for applying
    And I click the "Apply" button
    And a notification "Contact information sent." is shown


  Scenario: US5.3 Email missing "@"
    When I enter "juangmail.com" as an email for applying
    And I click the "Apply" button
    Then a notification "Email invalid" is shown

  Scenario: US5.4 Email without domain extension
    When I enter "juan@gmailcom" as an email for applying
    And I click the "Apply" button
    Then a notification "Email invalid" is shown

  Scenario: US5.5 Email with spaces
    When I enter "ju an@gmail.com" as an email for applying
    And I click the "Apply" button
    Then a notification "Email invalid" is shown

  Scenario: US5.6 Email without domain name
    When I enter "juan@.com" as an email for applying
    And I click the "Apply" button
    Then a notification "Email invalid" is shown
    

  Scenario: US5.7 Email with double domain extension
    When I enter "juan@gmail.com.ar" as an email for applying
    And I click the "Apply" button
    And a notification "Contact information sent." is shown

Feature: Job Offers with remuneration 
  In order to get employees
  As a job offerer
  I want to put a remuneration in offers

  Background:
  	Given I am logged in as job offerer

  Scenario: Create new offer with remuneration
    When I create a new offer with "1000" as a remuneration
    Then I should see "1000" in my offers list remuneration
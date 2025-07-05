
Scenario: on-demand with no offers
    Given there is Pepe user with a on-demand susbcription
    When I get the report for the current month
    Then Pepe should pay 0

Scenario: on-demand with one offer
    Given there is Pepe user with a on-demand susbcription
    And offer active in the current month
    When I get the report for the current month
    Then Pepe should pay 10    


Scenario: on-demand with no offers
=> 0

Scenario: on-demand with one offer
=> 10

Scenario: pro with no offers
=> 30

Scenario: pro with one offer
=> 30

Scenario: pro with seven offer
=> 44

Scenario: corp with no offers
=> 80


Scenario: corp with 10 offer
=> 80






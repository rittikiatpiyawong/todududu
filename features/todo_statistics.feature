Feature: Todo Statistics
  As a user
  I want to see statistics about my todos
  So that I can track my progress

  Background:
    Given I am on the todo homepage

  Scenario: Initial statistics with no todos
    Given I have no todos
    Then the total count should be 0
    And the pending count should be 0
    And the completed count should be 0

  Scenario: Statistics with mixed todos
    Given I have the following todos:
      | title           | completed |
      | Buy milk        | false     |
      | Walk the dog    | true      |
      | Read a book     | false     |
      | Write code      | true      |
      | Call mom        | false     |
    Then the total count should be 5
    And the pending count should be 3
    And the completed count should be 2

  Scenario: Statistics update when completing todos
    Given I have 3 pending todos
    When I complete 2 todos
    Then the pending count should be 1
    And the completed count should be 2
    And the total count should be 3

  Scenario: Statistics update when deleting todos
    Given I have 5 todos with 2 completed
    When I delete 1 completed todo
    Then the total count should be 4
    And the completed count should be 1
    And the pending count should be 3

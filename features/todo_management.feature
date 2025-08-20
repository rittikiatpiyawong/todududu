Feature: Todo Management
  As a user
  I want to manage my todos
  So that I can keep track of my tasks

  Background:
    Given I am on the todo homepage

  Scenario: Viewing the todo homepage
    Then I should see "Rittikiat Piyawong"
    And I should see "My Personal Todo List"
    And I should see a form to add new todos
    And I should see todo statistics

  Scenario: Adding a new todo
    When I fill in "todo_title" with "Buy groceries"
    And I click the add todo button
    Then I should see "Buy groceries" in the todo list
    And the total count should increase by 1
    And the pending count should increase by 1

  Scenario: Adding a todo with empty title
    When I fill in "todo_title" with ""
    And I click the add todo button
    Then I should not see any new todos in the list
    And I should see an error message

  Scenario: Completing a todo
    Given I have a todo "Learn Cucumber"
    When I check the todo "Learn Cucumber"
    Then the todo "Learn Cucumber" should be marked as completed
    And the completed count should increase by 1
    And the pending count should decrease by 1

  Scenario: Uncompleting a todo
    Given I have a completed todo "Write tests"
    When I uncheck the todo "Write tests"
    Then the todo "Write tests" should be marked as pending
    And the completed count should decrease by 1
    And the pending count should increase by 1

  Scenario: Deleting a todo
    Given I have a todo "Delete this task"
    When I delete the todo "Delete this task"
    Then I should not see "Delete this task" in the todo list
    And the total count should decrease by 1

  Scenario: Viewing empty todo list
    Given I have no todos
    Then I should see "No todos yet!"
    And I should see "Add your first todo to get started."

  Scenario: Viewing todo timestamps
    Given I have a todo "Check timestamps"
    Then I should see a timestamp for the todo "Check timestamps"

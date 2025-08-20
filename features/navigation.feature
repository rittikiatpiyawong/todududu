Feature: Navigation
  As a user
  I want to navigate between different pages
  So that I can access all features of the application

  Scenario: Accessing the brag document
    Given I am on the todo homepage
    When I click on "My Brag Document"
    Then I should be on the brag document page
    And I should see "Rittikiat Piyawong"
    And I should see "My Brag Document 2025"

  Scenario: Returning from brag document to homepage
    Given I am on the brag document page
    When I click on "Back to Todos"
    Then I should be on the todo homepage
    And I should see "My Personal Todo List"

  Scenario: Viewing brag document content
    Given I am on the brag document page
    Then I should see "เป้าหมายในปีนี้"
    And I should see "Technical Skills"
    And I should see "Self"
    And I should see "Team"
    And I should see "ODT Client"

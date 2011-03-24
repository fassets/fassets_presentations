Feature: User Management

  To allow different authors to manage their own content, some form of
  user management is needed.

  Scenario: A user authenticates himself to the system
    Given no User
    When I provide login as "fred" with password "vom Jupiter"
    Then I should be authenticated
Feature: Support different types of assets
  A central point in fassets are assets (hence the name).
  Users of the system want to create, read, update and delete
  different types of assets.
  
  Scenario: A user creates a File asset
    Given I am logged in as user "fred"
    When I create a "FileAsset" named "myFile.txt"
    Then my tray should contain a "FileAsset"

  Scenario: A user creates a Presentation
    Given I am logged in as user "fred"
    When I create a "Presentation" named "Flying Space-Ships"
    Then my tray should contain a "Presentation"

  Scenario: A user creates a Url and a File asset
    Given I am logged in as user "fred"
    When I create a "Url" named "google"
    And I create a "FileAsset" named "myFile.txt"
    Then my tray should contain a "Url"
    And my tray should contain a "FileAsset"


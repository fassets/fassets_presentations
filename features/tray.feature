Feature: The Tray - A tool to manage assets for a short period of time

  When working with fassets, users may want to temporarily store assets
  in a way that they have a fast and easy access to a set of assets they are
  currently working with.

  @wip
  Scenario: A user puts assets onto the tray
    Given I am logged in as user "fred"
    And this user has no assets on the tray
    When I add the following items to the tray:
      | name                    | type         |
      | Assembling space crafts | Presentation |
      | manual.pdf              | FileAsset    |
      | shuttle.png             | FileAsset    |
      | http://www.nasa.gov/    | Url          |
    Then I should see these 4 items on the tray named:
      | name                    |
      | Assembling space crafts |
      | manual.pdf              |
      | shuttle.png             |
      | http://www.nasa.gov/    |

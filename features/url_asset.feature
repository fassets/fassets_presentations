Feature: Url assets should handle external web references

  Since Fassets stores a large collection of content, this content
  needs to be referenced. One way to do this is to include web
  references. These references will also import certain features,
  available for specific sources into Fassets and makes these
  available to the user.

  Scenario: The user wants to store a link to some web-site
    Given I am logged in as user "fred"
    When I create a "Url" named "Heise Open"
    And I set the "url" attribute of the last asset to "http://heise.de/open"
    Then my tray should contain a "Url"

  Scenario: The user links to a youtube video


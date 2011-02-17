Feature: Navigating to a Repository page
    This covers all the different scenarios that will occur while we are
    navigating to our repository pages.
    
    Background:
        Given We need to show github user "codingjester"
        Given We need an anonymous repo "pyImgur" by "codingjester"
    
    Scenario: Without repository existing.
        Given I log in as "test_user"
        When I go to "codingjester/pyImgur"
        Then I should see "codingjester"
        And I should see "pyImgur"

Feature: Navigating to a Repository page
    This covers all the different scenarios that will occur while we are
    navigating to our repository pages.
    
    Background:
    
    Scenario: Without repository existing.
        Given We need to show github user "codingjester"
        Given We need an anonymous repo "pyImgur" by "codingjester"
        Given I log in as "test_user"
        When I go to "codingjester/pyImgur"

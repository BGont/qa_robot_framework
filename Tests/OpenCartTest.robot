*** Settings ***
Library    SeleniumLibrary
Resource    ../Resources/OpenCart.robot

Test Setup    Open Browser    browser=${BROWSER}
Test Teardown    Close Browser

*** Variables ***
${BROWSER}    chrome

*** Test Cases ***

Admin authentication
    Open admin login page
    Submit credentials    ${REGISTERED_ADMIN}
    Verify admin authentication
    Admin logout

Unregistered admin authentication
    Open admin login page
    Submit credentials    ${UNREGISTERED_ADMIN}
    Verify wrong credentials alert

Restore unregistered user password
    Open password restore page
    Submit email    ${UNREGISTERED_USER["email"]}
    Verify wrong email

Open admin catalog page
    Open admin login page
    Submit credentials    ${REGISTERED_ADMIN}
    Verify admin authentication
    Click admin catalog link
    Verify admin catalog page
    Admin logout


Check adding item to the shopping cart
    Open product page
    ${PRODUCT_NAME}=    Get product name
    Add to cart
    Open cart page
    Verify added product    ${PRODUCT_NAME}

*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    http://127.0.0.1
&{REGISTERED_ADMIN}    username=user    password=bitnami
&{UNREGISTERED_ADMIN}    username=fakeadmin    password=fakepassword
&{UNREGISTERED_USER}    email=fakeuser@fakeuser.fakeuser

*** Keywords ***
Open admin login page
    go to    ${URL}/admin/

Submit credentials    [Arguments]    ${CREDENTIALS}
    input text    name=username   ${CREDENTIALS["username"]}
    input text    name=password   ${CREDENTIALS["password"]}
    click button    xpath=//button[text()=' Login']

Verify admin authentication
    element should be visible    xpath=//header[@id='header']//a[contains(@href, 'logout')]

Admin logout
    click link    xpath=//header[@id='header']//a[contains(@href, 'logout')]

Verify wrong credentials alert
    element should contain    css=.alert     No match for Username and/or Password.

Open password restore page
    go to    ${URL}/index.php?route=account/forgotten

Submit email    [Arguments]    ${EMAIL}
    input text    name=email    ${EMAIL}
    click button    //input[contains(@type, 'submit') and contains(@value, 'Continue')]

Verify wrong email
    element should be visible
    ...    xpath=//div[contains(@class, 'alert') and contains(text(), 'E-Mail Address was not found')]

Click admin catalog link
    click link    xpath=//ul[@id='menu']/li[@id='menu-catalog']/a[text()=' Catalog']
    wait until element is visible    xpath=//ul[@id='menu']/li[@id='menu-catalog']//a[text()='Products']
    click link    xpath=//ul[@id='menu']/li[@id='menu-catalog']//a[text()='Products']

Verify admin catalog page
    wait until element is visible
    ...    xpath=//div[@id='content']/div[@class='container-fluid']/div[@class='row']/div[2]//table

Open product page
    go to    ${URL}/index.php?route=product/product&path=25_28&product_id=33

Get product name
    ${PRODUCT_NAME}=    get text    css=#content h1
    [Return]    ${PRODUCT_NAME}

Add to cart
    click button    css=button[id='button-cart']

Open cart page
    go to    ${URL}/index.php?route=checkout/cart

Verify added product    [Arguments]    ${PRODUCT_NAME}
    ${CART_PRODUCT}=    get text    css=#checkout-cart tr:nth-child(1) td:nth-child(2) > a
    should be equal    ${PRODUCT_NAME}    ${CART_PRODUCT}
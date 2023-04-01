//
//  UITestingDemoUITests.swift
//  UITestingDemoUITests
//
//  Created by Pedro Acevedo on 31/03/23.
//

import XCTest

final class UITestingDemoUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    //We test if Welcome Text exists and if the content it has is correct
    func testWelcome() throws {
        let welcome = app.staticTexts["Welcome!"]
     
        XCTAssert(welcome.exists)
    }
    
    func testWelcomeSecond() throws {
        let welcome = app.staticTexts.element
        XCTAssert(welcome.exists)
        XCTAssertEqual(welcome.label, "Welcome!")
    }
    
    func testLoginButton() throws {
        let login = app.buttons["loginButton"]
        XCTAssert(login.exists)
        XCTAssertEqual(login.label, "Login")
    }
    
    func testLoginFormAppearance() throws {
        app.buttons["loginButton"].tap()
        let loginNavBarTitle = app.staticTexts["Login"]
        XCTAssert(loginNavBarTitle.waitForExistence(timeout: 0.5))
    }
    
    func testLoginForm() throws {
        app.buttons["Login"].tap() //here we are also asserting the label "Login" exists
     
        let navBar = app.navigationBars.element
        XCTAssert(navBar.exists)
     
        let username = app.textFields["Username"]
        XCTAssert(username.exists)
     
        let password = app.secureTextFields["Password"]
        XCTAssert(password.exists)
     
        let login = app.buttons["loginNow"]
        XCTAssert(login.exists)
        XCTAssertEqual(login.label, "Login")
     
        let dismiss = app.buttons["Dismiss"]
        XCTAssert(dismiss.exists)
    }
    
    func testLoginDismiss() throws {
        app.buttons["Login"].tap()
        let dismiss = app.buttons["Dismiss"]
        dismiss.tap()
        XCTAssertFalse(dismiss.waitForExistence(timeout: 0.5)) //We assert the dismiss button wont exist after 0.5 seconds
    }
    //We test the text field functionality, we type text
    func testUsername() throws {
        app.buttons["Login"].tap()
     
        let username = app.textFields["Username"]
        username.tap()
        username.typeText("test")
     
        XCTAssertNotEqual(username.value as! String, "")
    }
    //We test password textfield functonality, but we used another way to enter text
    //IMPORTANT remember to enable keyboard on simulator using (Cmd + K)
    func testPassword() throws {
        app.buttons["Login"].tap()
     
        app.secureTextFields.element.tap()
        app.keys["p"].tap()
        app.keys["a"].tap()
        app.keys["s"].tap()
        app.keys["s"].tap()
        app.keyboards.buttons["Return"].tap()
     
        XCTAssertNotEqual(app.secureTextFields.element.value as! String, "")
    }
    //Here we test the whole flow, we expect for the login view to be dismissed at the end
    func testLogin() throws {
        app.buttons["Login"].tap()
     
        app.textFields.element.tap()
        app.textFields.element.typeText("test")
     
        app.secureTextFields.element.tap()
        app.secureTextFields.element.typeText("pass")
        app.keyboards.buttons["Return"].tap()
     
        let loginButton = app.buttons["loginNow"]
        loginButton.tap()
     
        XCTAssertFalse(loginButton.waitForExistence(timeout: 0.5))
    }
    //We test failed login attempt, with alert
    func testFailedLoginAlert() throws {
        app.buttons["Login"].tap()
        app.buttons["loginNow"].tap()
     
        XCTAssert(app.alerts.element.waitForExistence(timeout: 0.5))
     
        app.alerts.element.buttons["OK"].tap()
        XCTAssertFalse(app.alerts.element.exists)
    }
    //Function used to simplify the login steps
    func login() throws {
        app.buttons["Login"].tap()
     
        app.textFields.element.tap()
        app.textFields.element.typeText("test")
     
        app.secureTextFields.element.tap()
        app.secureTextFields.element.typeText("pass")
        app.keyboards.buttons["Return"].tap()
     
        app.buttons["loginNow"].tap()
    }
    //We check the textfield content before and after login
    func testWelcomeAfterLogin() throws {
        XCTAssert(app.staticTexts["Welcome!"].exists)
     
        try login()
     
        XCTAssert(app.staticTexts["Welcome test!"].exists)
        XCTAssertFalse(app.staticTexts["Welcome!"].exists)
    }
    
    func testLoginLogoutLabel() throws {
        XCTAssertEqual(app.buttons["loginButton"].label, "Login")
     
        try login()
     
        XCTAssertEqual(app.buttons["loginButton"].label, "Logout")
    }
    //Now we check the correct content is shown after a logout
    func testLogout() throws {
        try login()
     
        XCTAssert(app.staticTexts["Welcome test!"].exists)
        XCTAssertEqual(app.buttons["loginButton"].label, "Logout")
     
        app.buttons["loginButton"].tap()
     
        XCTAssert(app.staticTexts["Welcome!"].exists)
        XCTAssertEqual(app.buttons["loginButton"].label, "Login")
    }
    
    //testing picker
    func testColorTheme() throws {
        try login()
     
        let colorTheme = app.segmentedControls["colorTheme"]
        XCTAssert(colorTheme.exists)
        XCTAssert(colorTheme.buttons["Light"].isSelected)
     
        colorTheme.buttons["Dark"].tap()
        XCTAssert(colorTheme.buttons["Dark"].isSelected)
    }
    //testing slider
    func testTextSize() throws {
        try login()
     
        let textSize = app.sliders["slider"]
        XCTAssert(textSize.exists)
     
        textSize.adjust(toNormalizedSliderPosition: 0.75)
        XCTAssertGreaterThanOrEqual(textSize.value as! String, "0.7")
    }
    //testing wheel picker
    func testFontPicker() throws {
        try login()
     
        //let wheel = app.pickerWheels.element
        let wheel = app.pickers["fontPicker"].pickerWheels.element
        XCTAssert(wheel.exists)
        XCTAssertEqual(wheel.value as! String, "Arial")
     
        wheel.adjust(toPickerWheelValue: "Futura")
        XCTAssertEqual(wheel.value as! String, "Futura")
    }

    
    //For now we are not using the last 3 methods but they are given to us from the XCTest framework
    /*
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
     */
}

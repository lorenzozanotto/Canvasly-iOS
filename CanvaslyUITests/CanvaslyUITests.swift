//
//  CanvaslyUITests.swift
//  CanvaslyUITests
//
//  Created by Lorenzo Zanotto on 11/06/2016.
//  Copyright © 2016 Lorenzo Zanotto. All rights reserved.
//

import XCTest

class CanvaslyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    /// Testing the new Document creation
    func testDocumentCreation() {
        
        let app = XCUIApplication()
        app.navigationBars["My Canvas"].buttons["Create"].tap()
        app.textFields["enter the title"].tap()
        app.textFields["enter the title"]
        
        let element = app.otherElements.containingType(.NavigationBar, identifier:"Canvasly.EditorView").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let textView = element.childrenMatchingType(.TextView).element
        textView.tap()
        textView.tap()
        element.childrenMatchingType(.TextView).element
        app.navigationBars["Canvasly.EditorView"].buttons["My Canvas"].tap()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}

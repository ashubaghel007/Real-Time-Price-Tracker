//
//  RealTimePriceTrackerUITests.swift
//  RealTimePriceTrackerUITests
//
//  Created by Ashish Baghel on 25/11/2025.
//

import XCTest

final class RealTimePriceTrackerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testStocksFeedScreenLoads() throws {
        // Verify navigation title exists
        let navBar = app.navigationBars["Stocks Feed"]
        XCTAssertTrue(navBar.exists, "Stocks Feed screen should be visible")

        // Verify connection indicator exists (green or red)
        let connected = navBar.staticTexts["🟢"]
        let disconnected = navBar.staticTexts["🔴"]
        XCTAssertTrue(connected.exists || disconnected.exists, "Connection indicator should exist")

    }

    @MainActor
    func testStartStopButton() throws {
        let startButton = app.buttons["Start"]
        let stopButton = app.buttons["Stop"]

        if startButton.exists {
            startButton.tap()
            XCTAssertTrue(stopButton.waitForExistence(timeout: 1))
        } else if stopButton.exists {
            stopButton.tap()
            XCTAssertTrue(startButton.waitForExistence(timeout: 1))
        }
    }

    @MainActor
    func testDeepLinkNavigation() throws {
        // Launch app with deep link (symbol AAPL)
        let app = XCUIApplication()
        app.launchArguments = ["-deeplink", "stocks://symbol/AAPL"]
        app.launch()

        // Verify that the detail screen opened with correct symbol
        let symbolLabel = app.staticTexts["AAPL"]
        XCTAssertTrue(symbolLabel.waitForExistence(timeout: 2), "Detail screen should display AAPL")
    }
}

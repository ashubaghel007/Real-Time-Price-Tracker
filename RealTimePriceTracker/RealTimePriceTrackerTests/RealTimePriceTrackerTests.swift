//
//  RealTimePriceTrackerTests.swift
//  RealTimePriceTrackerTests
//
//  Created by Ashish Baghel on 25/11/2025.
//

import XCTest
@testable import RealTimePriceTracker

final class RTPTPriceTrackerViewModelTests: XCTestCase {
    
    var viewModel: RTPTPriceTrackerViewModel!
    var mockWebSocket: MockWebSocketClient!
    
    override func setUp() {
        super.setUp()
        mockWebSocket = MockWebSocketClient()
        viewModel = RTPTPriceTrackerViewModel(networkClient: mockWebSocket, symbolList: ["AAPL", "GOOG"])
    }
    
    override func tearDown() {
        viewModel = nil
        mockWebSocket = nil
        super.tearDown()
    }
    
    func testInitialSymbolsSetup() {
        let symbols = viewModel.state.symbols.map { $0.symbol }
        XCTAssertEqual(symbols, ["AAPL", "GOOG"], "Initial symbols should match the provided list")
    }
    
    func testToggleFeedStartsAndStops() {
        XCTAssertFalse(viewModel.state.isRunning)
        
        viewModel.toggleFeed()
        XCTAssertTrue(viewModel.state.isRunning)
        XCTAssertTrue(mockWebSocket.didConnect)
        
        viewModel.toggleFeed()
        XCTAssertFalse(viewModel.state.isRunning)
        XCTAssertTrue(mockWebSocket.didDisconnect)
    }
    
    func testApplyUpdateChangesPrice() {
        let expectation = XCTestExpectation(description: "Price updates")
        
        mockWebSocket.simulateIncomingMessage("AAPL:999.99")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let aapl = self.viewModel.state.symbols.first(where: { $0.symbol == "AAPL" })
            XCTAssertEqual(aapl?.price, 999.99)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSortingAfterUpdate() {
        let expectation = XCTestExpectation(description: "List is sorted descending")
        
        mockWebSocket.simulateIncomingMessage("AAPL:200")
        mockWebSocket.simulateIncomingMessage("GOOG:400")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let prices = self.viewModel.state.symbols.map { $0.price }
            XCTAssertEqual(prices, [400, 200], "Symbols should be sorted descending by price")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSendRandomPriceUpdates() {
        viewModel.toggleFeed() // start feed
        viewModel.sendRandomPriceUpdates()
        XCTAssertFalse(mockWebSocket.sentMessages.isEmpty, "Random price updates should be sent")
    }
    
    func testConnectionStateUpdates() {
        let expectation = XCTestExpectation(description: "Connection state updates")
        
        mockWebSocket.simulateConnectionState(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.state.isConnected)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

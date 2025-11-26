//
//  MockWebSocketClient.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 27/11/2025.
//
import Combine
@testable import RealTimePriceTracker

final class MockWebSocketClient: RTPTWebSocketClientProtocol {
    let messagePublisher = PassthroughSubject<String, Never>()
    let connectionStatePublisher = PassthroughSubject<Bool, Never>()
    
    private(set) var didConnect = false
    private(set) var didDisconnect = false
    private(set) var sentMessages: [String] = []
    
    func connect() {
        didConnect = true
        connectionStatePublisher.send(true)
    }
    
    func disconnect() {
        didDisconnect = true
        connectionStatePublisher.send(false)
    }
    
    func send(_ message: String) {
        sentMessages.append(message)
        // Optionally simulate a response
        messagePublisher.send(message)
    }
    
    // Helper to simulate incoming message
    func simulateIncomingMessage(_ message: String) {
        messagePublisher.send(message)
    }
    
    // Helper to simulate connection change
    func simulateConnectionState(_ connected: Bool) {
        connectionStatePublisher.send(connected)
    }
}

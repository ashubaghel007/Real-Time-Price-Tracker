//
//  RTPTWebSocketClient.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 25/11/2025.
//

import Foundation
import Combine

// MARK: - WebSocket Client Protocol
/// Protocol defining the basic interface for a WebSocket client.
/// Enables mocking/testing by decoupling the ViewModel from the real WebSocket implementation.
protocol RTPTWebSocketClientProtocol: AnyObject {
    /// Publishes incoming text messages from the WebSocket
    var messagePublisher: PassthroughSubject<String, Never> { get }
    
    /// Publishes the connection state (true = connected, false = disconnected)
    var connectionStatePublisher: PassthroughSubject<Bool, Never> { get }
    
    /// Connects to the WebSocket server
    func connect()
    
    /// Disconnects from the WebSocket server
    func disconnect()
    
    /// Sends a string message to the WebSocket server
    func send(_ message: String)
}

// MARK: - WebSocket Client
class RTPTWebSocketClient: ObservableObject, RTPTWebSocketClientProtocol {
    private var webSocketTask: URLSessionWebSocketTask?
    var messagePublisher = PassthroughSubject<String, Never>()
    var connectionStatePublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
  
    
    func connect() {
        guard webSocketTask == nil,
              let wssURL = RTPTConstants.wssURL else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: wssURL)
        webSocketTask?.resume()
        connectionStatePublisher.send(true)
        receive()
    }
    
    func send(_ message: String) {
        let wsMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(wsMessage) { error in
            if let error = error {
                print("Send error: \(error)")
            }
        }
    }
    
    // MARK: - Receive Messages
    /// Continuously listens for incoming WebSocket messages.
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Receive error: \(error)")
                self?.connectionStatePublisher.send(false)
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.messagePublisher.send(text)
                case .data(let data):
                    self?.messagePublisher.send("Received binary: \(data.count) bytes")
                @unknown default:
                    break
                }
            }
            // Keep listening
            self?.receive()
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        connectionStatePublisher.send(false)
    }
}

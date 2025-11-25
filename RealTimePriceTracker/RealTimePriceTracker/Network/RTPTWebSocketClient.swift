//
//  RTPTWebSocketClient.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 25/11/2025.
//

import Foundation
import Combine

class RTPTWebSocketClient: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    let messagePublisher = PassthroughSubject<String, Never>()
    let connectionStatePublisher = PassthroughSubject<Bool, Never>()
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
        connectionStatePublisher.send(false)
    }
}

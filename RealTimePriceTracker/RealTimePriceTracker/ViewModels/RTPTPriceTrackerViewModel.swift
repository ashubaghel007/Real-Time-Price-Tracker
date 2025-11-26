//
//  RTPTPriceTrackerViewModel.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 25/11/2025.
//

import Foundation
import Combine

// MARK: - ViewModel
/// ViewModel for managing the real-time stock price feed.
/// Uses a WebSocket client to receive live updates and maintains
/// the feed state and navigation path for SwiftUI NavigationStack.
final class RTPTPriceTrackerViewModel: ObservableObject {
    /// Current feed state (symbols, running state, connection status)
    @Published var state = RTPTFeedState()
    
    /// Navigation path for NavigationStack
    @Published var navigationPath: [StockSymbol] = [] // For NavigationStack

    private let networkClient: RTPTWebSocketClientProtocol
    private var timerCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private var symbolList: [String] = [String]()
    var isDarkMode: Bool = true 

    // MARK: - Init
    init(networkClient: RTPTWebSocketClientProtocol = RTPTWebSocketClient(),
         symbolList: [String] = RTPTConstants.symbolList) {
        self.networkClient = networkClient
        self.symbolList = symbolList
        setupInitialStockSymbolList()
        observeIncomingUpdates()
    }

    // MARK: - Setup Initial Symbols
    /// Populates the state with initial stock symbols with random prices
    private func setupInitialStockSymbolList() {
        state.symbols = symbolList.map {
            StockSymbol(symbol: $0,
                        price: Double.random(in: 100...500),
                        previousPrice: 0)
        }
        sortList()
    }

    // MARK: - Observe WebSocket Updates
    /// Subscribes to the WebSocket client's message and connection publishers
    private func observeIncomingUpdates() {
        // Subscribe to incoming messages
        networkClient.messagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.applyUpdate(text)
            }
            .store(in: &cancellables)

        // Subscribe to connection state changes
        networkClient.connectionStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ok in
                self?.state.isConnected = ok
            }
            .store(in: &cancellables)
    }

    // MARK: - Feed Control
    /// Toggles the feed between running and stopped
    func toggleFeed() {
        state.isRunning ? stopFeed() : startFeed()
        state.isRunning.toggle()
    }

    private func startFeed() {
        networkClient.connect()

        // Timer to send random price updates every 2 seconds
        timerCancellable = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                self?.sendRandomPriceUpdates()
            }
    }

    /// Stops the feed and disconnects the WebSocket
    private func stopFeed() {
        timerCancellable?.cancel()
        timerCancellable = nil
        networkClient.disconnect()
    }

     func sendRandomPriceUpdates() {
        for symbol in state.symbols {
            let newPrice = Double.random(in: 100...500)
            networkClient.send("\(symbol.symbol):\(newPrice)")
        }
    }

    // MARK: - Handle Incoming Updates
    /// Applies an incoming message to update the corresponding symbol
    /// - Parameter message: Expected format "AAPL:247.52"
    private func applyUpdate(_ message: String) {
        let parts = message.split(separator: ":")
        guard parts.count == 2,
              let newPrice = Double(parts[1])
        else { return }

        let name = String(parts[0])

        guard let index = state.symbols.firstIndex(where: { $0.symbol == name }) else { return }

        state.symbols[index] = state.symbols[index].updated(newPrice: newPrice)
        sortList()
    }

    // MARK: - Helper: Sort Symbols
    /// Sorts symbols in descending order based on price
    private func sortList() {
        state.symbols.sort { $0.price > $1.price }
    }
}

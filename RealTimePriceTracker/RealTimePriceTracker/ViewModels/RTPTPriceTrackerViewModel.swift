//
//  RTPTPriceTrackerViewModel.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 25/11/2025.
//

import Foundation
import Combine

final class RTPTPriceTrackerViewModel: ObservableObject {
    @Published var symbols: [StockSymbol] = []
    @Published var isRunning = false

    private let networkClient: RTPTWebSocketClient
    private var timerCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private var symbolList: [String] = [String]()

    // MARK: - Init
    init(networkClient: RTPTWebSocketClient,
         symbolList: [String] = RTPTConstants.symbolList) {
        self.networkClient = networkClient
        self.symbolList = symbolList
        setupInitialStockSymbolList()
        observeIncomingUpdates()
    }

    // MARK: - Setup
    private func setupInitialStockSymbolList() {
        symbols = symbolList.map {
            StockSymbol(symbol: $0,
                        price: Double.random(in: 100...500),
                        previousPrice: 0)
        }
        sortList()
    }

    private func observeIncomingUpdates() {
        networkClient.messagePublisher
            .sink { [weak self] text in self?.applyUpdate(text) }
            .store(in: &cancellables)
    }

    // MARK: - Feed Control
    func toggleFeed() {
        isRunning ? stopFeed() : startFeed()
        isRunning.toggle()
    }

    private func startFeed() {
        networkClient.connect()

        timerCancellable = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                self?.sendRandomPriceUpdates()
            }
    }

    private func stopFeed() {
        timerCancellable?.cancel()
        timerCancellable = nil
        networkClient.disconnect()
    }

    private func sendRandomPriceUpdates() {
        for symbol in symbols {
            let newPrice = Double.random(in: 100...500)
            networkClient.send("\(symbol.symbol):\(newPrice)")
        }
    }

    // MARK: - Handling Updates
    private func applyUpdate(_ message: String) {
        // Expected format: "AAPL:247.52"
        let parts = message.split(separator: ":")
        guard parts.count == 2,
              let newPrice = Double(parts[1])
        else { return }

        let name = String(parts[0])

        guard let index = symbols.firstIndex(where: { $0.symbol == name }) else { return }

        symbols[index] = symbols[index].updated(newPrice: newPrice)
        sortList()
    }

    private func sortList() {
        symbols.sort { $0.price > $1.price }
    }
}

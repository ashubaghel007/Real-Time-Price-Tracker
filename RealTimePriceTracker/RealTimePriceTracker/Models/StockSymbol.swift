//
//  StockSymbol.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 26/11/2025.
//

import Foundation

struct StockSymbol: Identifiable, Equatable, Hashable {
    let id = UUID()
    let symbol: String
    let price: Double
    let previousPrice: Double

    var change: Double { price - previousPrice }
    var isUp: Bool { change > 0 }
    var isDown: Bool { change < 0 }

    func updated(newPrice: Double) -> StockSymbol {
        StockSymbol(symbol: symbol, price: newPrice, previousPrice: price)
    }
}

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
    var price: Double
    var previousPrice: Double?

    var change: Double { price - (previousPrice ?? price) }
    var isUp: Bool { change > 0 }
    var isDown: Bool { change < 0 }
}

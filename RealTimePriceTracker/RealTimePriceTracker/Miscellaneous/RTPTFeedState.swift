//
//  RTPTFeedState.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 26/11/2025.
//
import Foundation

struct RTPTFeedState {
    var symbols: [StockSymbol] = []
    var isConnected: Bool = false
    var isRunning: Bool = false
}

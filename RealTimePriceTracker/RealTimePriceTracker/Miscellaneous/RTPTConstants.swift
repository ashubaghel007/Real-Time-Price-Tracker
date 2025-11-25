//
//  RTPTConstants.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 25/11/2025.
//

import Foundation

struct RTPTConstants {
    static let wssURL = URL(string: "wss://ws.postman-echo.com/raw")
    static let symbolList = [
        "AAPL","GOOG","AMZN","MSFT","TSLA","NVDA","META","NFLX","ADBE","INTC",
        "ORCL","IBM","AMD","BABA","UBER","LYFT","SHOP","CRM","PYPL","SQ",
        "KO","PEP","V","MA","DIS"
    ]
}

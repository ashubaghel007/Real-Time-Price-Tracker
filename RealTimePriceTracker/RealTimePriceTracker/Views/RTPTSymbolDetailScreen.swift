//
//  RTPTSymbolDetailScreen.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 26/11/2025.
//

import SwiftUI

struct RTPTSymbolDetailScreen: View {
    @ObservedObject var viewModel: SymbolDetailViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.symbol.symbol)
                .font(.largeTitle)
            
            HStack {
                Text(String(format: "%.2f", viewModel.symbol.price))
                    .font(.system(size: 40, weight: .bold))
                Text(viewModel.symbol.isUp ? "↑" : "↓")
                    .font(.largeTitle)
                    .foregroundColor(viewModel.symbol.isUp ? .green : .red)
            }
            
            Text("This is the detail view for \(viewModel.symbol.symbol). The price updates in real-time using a shared WebSocket connection.")
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.symbol.symbol)
    }
}

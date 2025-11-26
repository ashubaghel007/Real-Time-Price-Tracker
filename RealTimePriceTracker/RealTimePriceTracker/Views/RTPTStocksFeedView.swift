//
//  RTPTStocksFeedView.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 26/11/2025.
//

import SwiftUI

struct RTPTStocksFeedView: View {
    @StateObject var viewModel: RTPTPriceTrackerViewModel = RTPTPriceTrackerViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.state.symbols) { item in
                    NavigationLink {
                        RTPTSymbolDetailScreen(
                            viewModel: SymbolDetailViewModel(
                                symbol: item,
                                parentViewModel: viewModel
                            )
                        )
                    } label: {
                        RTPTFeedRow(model: item)
                    }
                }
            }
            .navigationTitle("Stocks Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.state.isConnected ? "🟢" : "🔴")
                        .font(.largeTitle)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.state.isRunning ? "Stop" : "Start") {
                        viewModel.toggleFeed()
                    }
                }
            }
        }
    }
}

struct RTPTFeedRow: View {
    let model: StockSymbol

    var body: some View {
        HStack {
            Text(model.symbol)
                .font(.headline)
            Spacer()
            Text(String(format: "%.2f", model.price))
                .font(.body)
            Text(model.isUp ? "↑" : "↓")
                .foregroundColor(model.isUp ? .green : .red)
                .font(.title3)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    RTPTStocksFeedView(viewModel: RTPTPriceTrackerViewModel())
}

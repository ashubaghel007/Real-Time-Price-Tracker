//
//  RTPTStocksFeedView.swift
//  RTPTStocksFeedView
//
//  Created by Ashish Baghel on 26/11/2025.
//
import SwiftUI

struct RTPTStocksFeedView: View {
    @StateObject var viewModel: RTPTPriceTrackerViewModel = RTPTPriceTrackerViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack {
                List(viewModel.state.symbols) { item in
                    NavigationLink(value: item) {
                        RTPTFeedRow(model: item)
                    }
                    .listRowBackground(viewModel.isDarkMode ? Color.black.opacity(0.2) : Color.white)
                }
            }
            .navigationTitle("Stocks Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.state.isConnected ? "🟢" : "🔴")
                        .font(.largeTitle)
                        .foregroundColor(viewModel.isDarkMode ? .white : .black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.state.isRunning ? "Stop" : "Start") {
                        viewModel.toggleFeed()
                    }
                    .foregroundColor(viewModel.isDarkMode ? .white : .blue)
                }
            }
            .background(viewModel.isDarkMode ? Color.black : Color(.systemGroupedBackground))
            .navigationDestination(for: StockSymbol.self) { symbol in
                RTPTSymbolDetailScreen(
                    viewModel: SymbolDetailViewModel(symbol: symbol, parentViewModel: viewModel)
                )
            }
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
    }

    // MARK: - Deep Link Handling
    private func handleDeepLink(_ url: URL) {
        // Expecting format: stocks://symbol/AAPL
        guard url.scheme == "stocks",
              url.host == "symbol",
              let symbolString = url.pathComponents.dropFirst().first,
              let symbol = viewModel.state.symbols.first(where: { $0.symbol == symbolString })
        else { return }

        // Navigate to the symbol details
        viewModel.navigationPath.append(symbol)
    }
}


struct RTPTFeedRow: View {
    let model: StockSymbol
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Text(model.symbol)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            Text(String(format: "%.2f", model.price))
                .font(.body)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Text(model.isUp ? "↑" : "↓")
                .foregroundColor(model.isUp ? .green : .red)
                .font(.title3)
        }
        .padding(.vertical, 6)
        .cornerRadius(8)
    }
}

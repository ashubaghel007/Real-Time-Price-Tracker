import SwiftUI

struct RTPTStocksFeedView: View {
    @StateObject var viewModel: RTPTPriceTrackerViewModel = RTPTPriceTrackerViewModel()
    @Environment(\.colorScheme) var colorScheme
    
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
                    .listRowBackground(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white)
                }
            }
            .navigationTitle("Stocks Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.state.isConnected ? "🟢" : "🔴")
                        .font(.largeTitle)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.state.isRunning ? "Stop" : "Start") {
                        viewModel.toggleFeed()
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .blue)
                }
            }
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
        }
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light) // we can also plug this theme with UI to update as per user choice
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

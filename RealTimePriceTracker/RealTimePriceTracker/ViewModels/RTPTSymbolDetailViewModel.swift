//
//  RTPTSymbolDetailViewModel.swift
//  RealTimePriceTracker
//
//  Created by Ashish Baghel on 26/11/2025.
//

import Foundation
import Combine

final class SymbolDetailViewModel: ObservableObject {
    @Published var symbol: StockSymbol

    private let parent: RTPTPriceTrackerViewModel
    private var cancellables = Set<AnyCancellable>()

    init(symbol: StockSymbol, parentViewModel: RTPTPriceTrackerViewModel) {
        self.symbol = symbol
        self.parent = parentViewModel
        observeParent()
    }

    private func observeParent() {
        parent.$state
            .map { state in
                state.symbols.first(where: { $0.symbol == self.symbol.symbol })
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedSymbol in
                self?.symbol = updatedSymbol
            }
            .store(in: &cancellables)
    }
}

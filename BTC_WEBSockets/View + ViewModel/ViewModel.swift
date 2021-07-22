//
//  ViewModel.swift
//  ViewModel
//
//  Created by Nikolay Beznos on 22.07.2021.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    let networkService: NetworkService = NetworkManager()
    @Published var isConnected: Bool = false
    @Published var price: String = ""
    
    var bag = Set<AnyCancellable>()

    init() {
        networkService.channel.sink { [weak self] channel in
            guard let self = self else { return }
            if let priceString = channel?.price_str {
                self.price = priceString
            }
        }
        .store(in: &bag)
    }
    
    func start() {
        networkService.isConnected.sink { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                self.networkService.subscribeToPair(.btcusd)
            }
        }
        .store(in: &bag)
    }
}

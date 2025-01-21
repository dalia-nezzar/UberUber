//
//  DeliveryViewModel.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation

class DeliveryViewModel: ObservableObject {
    enum State {
        case notAvailable
        case loading
        case success(data: Delivery)
        case successes(data: [Delivery])
        case failed(error: Error)
    }
    
    
    
    @Published var state: State = .notAvailable

    let service: APIService
    
    init(service: APIService) {
        self.service = service
    }
    
    @MainActor
    func getDeliveries(client_id: String) async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchDeliveries(client_id: client_id)
            self.state = .successes(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    @MainActor
    func getDeliveries() async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchDeliveries()
            self.state = .successes(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
}

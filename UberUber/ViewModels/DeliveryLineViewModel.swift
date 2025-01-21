//
//  DeliveryLineViewModel.swift
//  UberUber
//
//  Created by nicolas noah on 21/01/2025.
//

import Foundation

class DeliveryLineViewModel: ObservableObject {
    enum State {
        case notAvailable
        case loading
        case success(data: Driver)
        case successes(data: [Driver])
        case failed(error: Error)
    }
    
    
    
    @Published var state: State = .notAvailable
    
    let service: APIService
    
    init(service: APIService) {
        self.service = service
    }
    
    @MainActor
    func getDeliveryLines(delivery_id: String) async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchDeliveryLine(delivery_id: delivery_id)
            self.state = .successes(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
}

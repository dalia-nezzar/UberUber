//
//  CartViewModel.swift
//  UberUber
//
//  Created by nezzar dalia on 07/01/2025.
//

import Foundation


class CartViewModel: ObservableObject {
    enum State {
        case notAvailable
        case loading
        case success(data: Driver)
        case successes(data: [Driver])
        case emptySuccess(data: String)
        case failed(error: Error)
    }
    
    @Published var state: State = .notAvailable

    let service: APIService
    
    init(service: APIService) {
        self.service = service
    }

    
    @MainActor
    func addDriverToCart(client_id:String, driver_id: String) async {
        self.state = .loading
        do {
            await service.addDriverToCart(client_id: client_id, driver_id: driver_id)
            let apiResponse = try await service.fetchCart(client_id: client_id)
            self.state = .successes(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }


    @MainActor
    func getCart(client_id: String) async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchCart(client_id: client_id)
            self.state = .successes(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
        }
    }
    
    
    @MainActor
    func deleteDriverFromCart(client_id: String, driver_id: String) async {
        self.state = .loading
        do {
            await service.deleteDriverFromCart(client_id: client_id, driver_id: driver_id)
            let apiResponse = try await service.fetchCart(client_id: client_id)
            self.state = .successes(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }

    
    

    
}




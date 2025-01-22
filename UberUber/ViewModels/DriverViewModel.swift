//
//  DriverViewModel.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation


class DriverViewModel: ObservableObject {
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
    func getDriver(id_driver: String) async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchDriver(id_driver: id_driver)
            self.state = .success(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    @MainActor
    func getDrivers() async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchDrivers()
            self.state = .successes(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
    
}

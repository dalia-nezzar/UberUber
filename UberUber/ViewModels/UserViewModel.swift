//
//  UserViewModel.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    enum State {
        case notAvailable
        case loading
        case success(data: User)
        case failed(error: Error)
    }
    
    @Published var state: State = .notAvailable

    let service: APIService
    
    init(service: APIService) {
        self.service = service
    }
    
    @MainActor
    func getUser(email: String) async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchUser(email: email)
            self.state = .success(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    @MainActor
    func registerUser(firstname: String, lastname: String, email: String, birthdate: Date, image_url: URL, is_alive: Int, allow_criminal_record: Int, wants_extra_napkins: Int) async {
        self.state = .loading
        do {
            await service.registerUser(firstname: firstname, lastname: lastname, email: email, birthdate: birthdate, image_url: image_url, is_alive: is_alive, allow_criminal_record: allow_criminal_record, wants_extra_napkins: wants_extra_napkins)
            let apiResponse = try await service.fetchUser(email: email)
            self.state = .success(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
        }
    }

    
}

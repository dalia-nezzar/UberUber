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
    func getUser(email: String, password: String) async {
        self.state = .loading
        do {
            let apiResponse = try await service.fetchUser(email: email, password: password)
            self.state = .success(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    @MainActor
    func registerUser(firstname: String, lastname: String, email: String, password: String, birthdate: Date, image_url: URL, is_alive: Int, allow_criminal_record: Int, wants_extra_napkins: Int) async {
        self.state = .loading
        do {
            await service.registerUser(firstname: firstname, lastname: lastname, email: email, password: password, birthdate: birthdate, image_url: image_url, is_alive: is_alive, allow_criminal_record: allow_criminal_record, wants_extra_napkins: wants_extra_napkins)
            let apiResponse = try await service.fetchUser(email: email, password: password)
            self.state = .success(data: apiResponse)
        } catch {
            self.state = .failed(error: error)
        }
    }
    
    
    @MainActor
    func editUser(id_client: String, firstname: String, lastname: String, email: String, password: String, birthdate: Date, image_url: URL, is_alive: Int, allow_criminal_record: Int, wants_extra_napkins: Int) async {
            let currentState = self.state
            
            do {
                await service.editUser(
                    id_client: id_client,
                    firstname: firstname,
                    lastname: lastname,
                    email: email,
                    password: password,
                    birthdate: birthdate,
                    image_url: image_url,
                    is_alive: is_alive,
                    allow_criminal_record: allow_criminal_record,
                    wants_extra_napkins: wants_extra_napkins
                )
                
                // Mettre à jour directement l'utilisateur actuel sans passer par loading
                if case .success(let currentUser) = currentState {
                    let updatedUser = User(
                        id_client: id_client,
                        firstname: firstname,
                        lastname: lastname,
                        email: email,
                        password: password,
                        birthdate: formatDateForAPI(birthdate),
                        image_url: image_url,
                        is_alive: is_alive,
                        allow_criminal_record: allow_criminal_record,
                        wants_extra_napkins: wants_extra_napkins,
                        created_at: currentUser.created_at
                    )
                    self.state = .success(data: updatedUser)
                    
                    let apiResponse = try await service.fetchUser(email: email, password: password)
                }
            } catch {
                self.state = .failed(error: error)
            }
        }
        
        private func formatDateForAPI(_ date: Date) -> String {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return isoFormatter.string(from: date)
        }

    
}

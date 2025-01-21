//
//  APIService.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation


struct APIService {
    
    enum APIError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
        case invalidParameter
        case NOT_FOUND
    }
    
    struct baseURL {
        static var apiURL = "https://uberuber.factoryfields.com/api/"
    }
    
    /** 
     *  Get specific user by email
     *  email: String
     */
    func fetchUser(email: String) async throws -> User {
        
        let endpoint = baseURL.apiURL + "clients/email/" + email
        
        let url = URL(string: endpoint)
        
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidStatusCode
        }
        
        let decodeData = try JSONDecoder().decode(User.self, from: data)
        
        return decodeData
        
    }
    
    /**
     *  Register new user
     *  firstname: String
     *  lastname: String
     *  email: String
     *  birthdate: Date
     *  image_url: URL
     *  is_alive: Int
     *  allow_criminal_record: Int
     *  wants_extra_napkins: Int
     */
    func registerUser(firstname: String, lastname: String, email: String, birthdate: Date, image_url: URL, is_alive: Int, allow_criminal_record: Int, wants_extra_napkins: Int) async {
        
        let headers = ["Content-Type": "text/plain;charset=UTF-8"]

        let request = NSMutableURLRequest(url: NSURL(string: baseURL.apiURL + "clients")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse as Any)
          }
        })

        dataTask.resume()
        
        
    }
    
    
    
    /**
     * Get driver by ID
     * driver_id: String
     */
    func fetchDriver(driver_id: String) async throws -> Driver {
        
        let endpoint = baseURL.apiURL + "drivers/" + driver_id
        
        let url = URL(string: endpoint)
        
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidStatusCode
        }
        
        let decodeData = try JSONDecoder().decode(Driver.self, from: data)
        
        return decodeData
        
        
    }
    
    /**
     * Get all drivers
     */
    func fetchDrivers() async throws -> [Driver] {
        
    
        let endpoint = baseURL.apiURL + "drivers/"
        
        let url = URL(string: endpoint)
        
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidStatusCode
        }
        
        let decodeData = try JSONDecoder().decode([Driver].self, from: data)
        
        return decodeData
    }
    
    
    /**
     * Get cart based on user ID
     * client_id: String
     */
    func fetchCart(client_id: String) async throws -> [Driver] {
        
        let endpoint = baseURL.apiURL + "clients/" + client_id + "/cart"
        
        let url = URL(string: endpoint)
        
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidStatusCode
        }
        
        let decodeData = try JSONDecoder().decode([Driver].self, from: data)
        
        return decodeData
        
    }
    
    
    /**
     * Add a driver to the cart
     * driver_id: String
     */
    func addDriverToCart(client_id: String, driver_id: String) async {
        let headers = ["Content-Type": "application/json"]

        let request = NSMutableURLRequest(url: NSURL(string: baseURL.apiURL + "clients/" + client_id + "/cart/" + driver_id)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse as Any)
          }
        })

        dataTask.resume()
    }
    
    /**
     * Delete a driver from the cart
     * client_id: String
     * driver_id: String
     */
    func deleteDriverFromCart(client_id: String, driver_id: String) async {
        let headers = ["Content-Type": "text/plain;charset=UTF-8"]

        let request = NSMutableURLRequest(url: NSURL(string: "clients/" + client_id + "/cart/" + driver_id)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse as Any)
          }
        })

        dataTask.resume()
    }
    
    
    
    /**
     * Get delivery based on client ID
     * client_id: String
     */
    func fetchDeliveries(client_id: String) async throws -> [Delivery] {
        
        let endpoint = baseURL.apiURL + "clients/" + client_id + "/deliveries"
        
        let url = URL(string: endpoint)
        
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidStatusCode
        }
        
        let decodeData = try JSONDecoder().decode([Delivery].self, from: data)
        
        return decodeData
        
    }
    
    
    /**
     * Get delivery line
     * delivery_id
     */
    func fetchDeliveryLine(delivery_id: String) async throws -> [Driver] {
        
        let endpoint = baseURL.apiURL + "deliveries/" + delivery_id + "/lines"
        
        let url = URL(string: endpoint)
        
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidStatusCode
        }
        
        let decodeData = try JSONDecoder().decode([Driver].self, from: data)
        
        return decodeData
    }
    
    
    /**
     * Order a delivery
     * client_id: String
     */
    func orderDelivery(client_id: String) async {
        let headers = ["Content-Type": "text/plain;charset=UTF-8"]

        let request = NSMutableURLRequest(url: NSURL(string: "deliveries/" + client_id)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse as Any)
          }
        })

        dataTask.resume()
    }
    
    
    
    

}


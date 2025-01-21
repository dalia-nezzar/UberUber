//
//  User.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation

struct User: Decodable, Hashable {
    var id_client: String
    var firstname: String
    var lastname: String
    var email: String
    var birthdate: String
    var image_url: URL
    var is_alive: Int
    var allow_criminal_record: Int
    var wants_extra_napkins: Int
    var created_at: String
}

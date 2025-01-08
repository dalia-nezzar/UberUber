//
//  Driver.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation

struct Driver: Decodable, Hashable {
    var id_driver: String
    var firstname: String
    var lastname: String
    var email: String
    var price: Decimal
    var image_url: URL
    var has_criminal_record: Int
    var has_driving_licence: Int
    var days_since_last_accident: Int
    var description: String
    var created_at: Date
}

//
//  DeliveryLine.swift
//  UberUber
//
//  Created by nicolas noah on 21/01/2025.
//

import Foundation


struct DeliveryLine: Decodable, Hashable {
    var id_driver: String
    var firstname: String
    var lastname: String
    var email: String
    var price: String
    var image_url: String
    var has_criminal_record: String
    var has_driving_licence: String
    var days_since_last_accident: String
    var description: String
    var created_at: String
    var id_delivery: String
}

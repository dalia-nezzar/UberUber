//
//  Delivery.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation

struct Delivery: Decodable, Hashable {
    var id_delivery: String
    var delivery_date: String
    var total_price: String
    var state: String
    var id_client: String
    var is_alive: Int
    var allow_criminal_record: Int
    var wants_extra_napkins: Int
    var created_at: String
}

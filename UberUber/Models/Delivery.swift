//
//  Delivery.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import Foundation

struct Delivery: Decodable, Hashable {
    var id_delivery: String
    var delivery_date: Date
    var total_price: Decimal
    var state: String
    var id_client: String
    var created_at: Date
}

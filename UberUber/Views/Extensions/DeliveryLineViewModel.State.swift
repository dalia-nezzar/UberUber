//
//  DeliveryLineViewModel.State.swift
//  UberUber
//
//  Created by nezzar dalia on 22/01/2025.
//

import SwiftUI

extension DeliveryLineViewModel.State {
    var drivers: [Driver] {
        if case .successes(let drivers) = self {
            return drivers
        }
        return []
    }
}

//
//  FilterButtonDeliveries.swift
//  UberUber
//
//  Created by nicolas noah on 21/01/2025.
//

import SwiftUI

struct FilterButtonDeliveries: View {
    let filter: DeliveryView.DeliveryFilter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: filter.icon)
                Text(filter.rawValue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color(hex: "#28AFB0") : Color.gray.opacity(0.1))
            )
            .foregroundColor(isSelected ? .white : Color(hex: "#19647E"))
            .fontWeight(isSelected ? .bold : .medium)
        }
    }
}

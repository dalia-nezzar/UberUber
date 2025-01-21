//
//  SwiftUIView.swift
//  UberUber
//
//  Created by nicolas noah on 21/01/2025.
//

import SwiftUI

struct SingleDeliveryView: View {
    let delivery: Delivery
    
    var body: some View {
        VStack {
            Text("Single Delivery View")
                .font(.largeTitle)
                .padding()
            Text("Delivery ID: \(delivery.id_delivery)")
                .font(.title2)
            Spacer()
        }
        .navigationTitle("Delivery Details")
        .padding()
    }
}

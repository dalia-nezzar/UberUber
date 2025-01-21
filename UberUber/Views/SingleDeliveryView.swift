//
//  SwiftUIView.swift
//  UberUber
//
//  Created by nicolas noah on 21/01/2025.
//

import SwiftUI

struct SingleDeliveryView: View {
    let delivery: Delivery
    @StateObject private var viewModel: DeliveryLineViewModel
    
    init(delivery: Delivery, viewModel: DeliveryLineViewModel = DeliveryLineViewModel(service: APIService())) {
            self.delivery = delivery
            _viewModel = StateObject(wrappedValue: viewModel)
        }
    
    var formattedPrice: String {
        if let price = Double(delivery.total_price) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "EUR"
            return formatter.string(from: NSNumber(value: price)) ?? "€\(delivery.total_price)"
        }
        return "€\(delivery.total_price)"
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: delivery.delivery_date) else { return "Date invalide" }
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Delivery Details
            VStack(alignment: .leading, spacing: 8) {
                Text("Identifiant commande: \(delivery.id_delivery)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: "person.circle")
                    Text("Client: \(delivery.id_client)")
                }
                
                HStack {
                    Image(systemName: "calendar.circle")
                    Text("Course prévue le \(formattedDate)")
                }
                
                HStack {
                    Image(systemName: "eurosign.circle")
                    Text("Total: \(formattedPrice)")
                }
                
                HStack {
                    Image(systemName: "flag.circle")
                    Text("State: \(delivery.state)")
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // Delivery Lines
            Text("Delivery Lines")
                .font(.headline)
                .padding(.horizontal)

            
            Spacer()
        }
        .navigationTitle("Ta commande")
        .onAppear {
            Task {
                await viewModel.getDeliveryLines(delivery_id: delivery.id_delivery)
            }
        }
    }
}

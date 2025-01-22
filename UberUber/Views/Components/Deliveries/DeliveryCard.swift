//
//  DeliveryCard.swift
//  UberUber
//
//  Created by nezzar dalia on 22/01/2025.
//

import SwiftUI

struct DeliveryCard: View {
    let delivery: Delivery
    
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
    
    var stateColor: Color {
        switch delivery.state {
        case "En attente": return Color(hex: "#28AFB0")
        case "En cours de validation": return Color(hex: "#19647E")
        case "Complété": return Color(hex: "#00ad45")
        case "Annulé": return .gray
        case "Accidenté": return Color(hex: "#684885")
        case "Arrêté par la police": return Color(hex: "#318ce7")
        default: return .gray
        }
    }
    
    var stateText: String {
        switch delivery.state {
        case "En attente": return "En attente"
        case "En cours de validation": return "En cours"
        case "Complété": return "Complété"
        case "Annulé": return "Annulé"
        case "Accidenté": return "Accidenté"
        case "Arrêté par la police": return "Arrêté par la police"
        default: return delivery.state
        }
    }
    
    var body: some View {
        NavigationLink(destination: SingleDeliveryView(delivery: delivery)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(delivery.id_delivery)
                        .font(.headline)
                    Spacer()
                    Text(stateText)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(stateColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Image(systemName: "calendar.circle")
                        Text("Course prévue le \(formattedDate)")
                    }
                    
                    HStack {
                        Image(systemName: "eurosign.circle")
                        Text("Total: \(formattedPrice)")
                    }
                }
                .foregroundColor(.black.opacity(0.8))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

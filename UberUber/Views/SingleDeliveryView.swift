//
//  SwiftUIView.swift
//  UberUber
//
//  Created by nicolas noah on 21/01/2025.
//

import SwiftUI

struct SingleDeliveryView: View {
    let delivery: Delivery
    @EnvironmentObject var deliveryViewModel: DeliveryViewModel
    @EnvironmentObject var deliveryLineViewModel: DeliveryLineViewModel
    
    // MARK: - Computed Properties
    private var formattedPrice: String {
        guard let price = Double(delivery.total_price) else {
            return "€\(delivery.total_price)"
        }
        
        return price.formatted(.currency(code: "EUR"))
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: delivery.delivery_date) else {
            return "Date invalide"
        }
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }
    
    // MARK: - View Components
    private var deliveryHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Commande #\(delivery.id_delivery)")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Votre ID client: \(delivery.id_client)")
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var deliveryDetails: some View {
        VStack(spacing: 16) {
            InfoCard {
                DetailRow(icon: "calendar", title: "Date de la course", value: formattedDate)
                DetailRow(icon: "heart.fill", title: "En vie", value: delivery.is_alive == 1 ? "Oui" : "Non")
                DetailRow(icon: "exclamationmark.shield.fill", title: "Casier judiciaire", value: delivery.allow_criminal_record == 1 ? "Toléré" : "Non toléré")
                DetailRow(icon: "square.stack.fill", title: "Serviettes supplémentaires", value: delivery.wants_extra_napkins == 1 ? "Oui" : "Non")
            }
            
            InfoCard {
                DetailRow(icon: "eurosign.circle.fill", title: "Total", value: formattedPrice, highlighted: true)
                DetailRow(icon: "flag.circle.fill", title: "Status", value: delivery.state.capitalized)
            }
        }
    }
    
    private var driversList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(deliveryLineViewModel.state.drivers.count > 1 ? "Vos conducteurs" : "Votre conducteur")
                .font(.title2)
                .fontWeight(.semibold)
            
            switch deliveryLineViewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)
            case .successes(let drivers):
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                    ForEach(drivers, id: \.id_driver) { driver in
                        DriverCartCard(driver: driver)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            case .failed(let error):
                ErrorView(error: error)
            default:
                EmptyView()
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                deliveryHeader
                deliveryDetails
                driversList
            }
            .padding()
        }
        .navigationTitle("Détails de la commande")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await deliveryLineViewModel.getDeliveryLines(delivery_id: delivery.id_delivery)
        }
    }
}

// MARK: - Supporting Views
struct InfoCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var highlighted: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(highlighted ? .blue : .secondary)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(highlighted ? .semibold : .regular)
        }
    }
}

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Erreur")
                .font(.headline)
            
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - State Extension
extension DeliveryLineViewModel.State {
    var drivers: [Driver] {
        if case .successes(let drivers) = self {
            return drivers
        }
        return []
    }
}

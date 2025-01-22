//
//  Deliveries.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

struct DeliveryView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var deliveryViewModel: DeliveryViewModel
    
    @State private var searchText: String = ""
    @State private var selectedFilter: DeliveryFilter = .all
    
    
    // Enumération pour les filtres
    enum DeliveryFilter: String, CaseIterable {
        case all = "Toutes"
        case pending = "En attente"
        case inProgress = "En cours"
        case delivered = "Complété"
        
        var icon: String {
            switch self {
            case .all: return "rectangle.grid.2x2"
            case .pending: return "figure.stand"
            case .inProgress: return "figure.run"
            case .delivered: return "figure.roll"
            }
        }
    }
    
    var filteredDeliveries: [Delivery] {
        guard case .successes(let deliveries) = deliveryViewModel.state else { return [] }
        
        var filtered = deliveries
        
        if !searchText.isEmpty {
            filtered = filtered.filter { delivery in
                delivery.id_delivery.lowercased().contains(searchText.lowercased()) ||
                delivery.id_client.lowercased().contains(searchText.lowercased())
            }
        }
        
        switch selectedFilter {
        case .all:
            return filtered
        case .pending:
            return filtered.filter { $0.state == "En attente" }
        case .inProgress:
            return filtered.filter { $0.state == "En cours de validation" }
        case .delivered:
            return filtered.filter { $0.state == "Complété" }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#28AFB0"),
                        Color(hex: "#DDCECD")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black.opacity(0.5))
                        
                        TextField("Rechercher une réservation", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color.white)
                    
                    // Barre de filtres
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(DeliveryFilter.allCases, id: \.self) { filter in
                                FilterButtonDeliveries(
                                    filter: filter,
                                    isSelected: selectedFilter == filter,
                                    action: { selectedFilter = filter }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color.white)
                
                    
                    // Liste des livraisons
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                            switch deliveryViewModel.state {
                            case .notAvailable, .loading:
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .frame(maxWidth: .infinity, minHeight: 300)
                            case .successes:
                                ForEach(filteredDeliveries, id: \.id_delivery) { delivery in
                                    DeliveryCard(delivery: delivery)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            case .failed(let error):
                                Text("Erreur: \(error.localizedDescription)")
                                    .foregroundColor(.red)
                            default:
                                EmptyView()
                            }
                        }
                        .padding()
                        .animation(.spring(), value: selectedFilter)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("TesRéservations")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.trailing, 180)
                }
            }
            .task {
                if case .success(let user) = userViewModel.state {
                    await deliveryViewModel.getDeliveries(client_id: user.id_client)
                }
                // await deliveryViewModel.getDeliveries();
            }
        }
    }
}



#Preview {
    DeliveryView()
}

//
//  ContentView.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

import SwiftUI

struct DriversView: View {
    @StateObject private var viewModel: DriverViewModel
    @State private var selectedFilter: DriverFilter = .all
    
    init(viewModel: DriverViewModel = DriverViewModel(service: APIService())) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // Énumération pour les filtres
    enum DriverFilter: String, CaseIterable {
        case all = "Tous"
        case safest = "Plus sûrs"
        case cheapest = "Moins chers"
        case newest = "Nouveaux"
        
        var icon: String {
            switch self {
            case .all: return "rectangle.grid.2x2"
            case .safest: return "shield.checkered"
            case .cheapest: return "eurosign.circle"
            case .newest: return "star"
            }
        }
    }
    
    var filteredDrivers: [Driver] {
        guard case .successes(let drivers) = viewModel.state else { return [] }
        
        switch selectedFilter {
        case .all:
            return drivers
        case .safest:
            return drivers.sorted { $0.days_since_last_accident > $1.days_since_last_accident }
        case .cheapest:
            return drivers.sorted { $0.price < $1.price }
        case .newest:
            return drivers.sorted { $0.created_at > $1.created_at }
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
                    // Barre de filtres
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(DriverFilter.allCases, id: \.self) { filter in
                                FilterButton(
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
                    
                    // Liste des conducteurs
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                            switch viewModel.state {
                            case .notAvailable, .loading:
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .frame(maxWidth: .infinity, minHeight: 300)
                            case .successes:
                                ForEach(filteredDrivers, id: \.id_driver) { driver in
                                    DriverCard(driver: driver)
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
                    Image("NosConducteurs")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.trailing, 150)
                }
            }
            .task {
                await viewModel.getDrivers()
            }
        }
    }
}

struct FilterButton: View {
    let filter: DriversView.DriverFilter
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


struct DriverCard: View {
    let driver: Driver
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: driver.image_url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundColor(Color(hex: "#19647E").opacity(0.3))
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(driver.firstname) \(driver.lastname)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#19647E"))
                
                HStack {
                    Text("Prix:")
                        .fontWeight(.semibold)
                    Text(driver.price + "€")
                        .foregroundColor(Color(hex: "#28AFB0"))
                        .fontWeight(.bold)

                }
                
                // Statistiques
                HStack(spacing: 12) {
                    StatBadge(
                        icon: "car.fill",
                        text: "\(driver.days_since_last_accident) jours",
                        color: driver.days_since_last_accident > 365 ? .green : .orange
                    )
                    
                    StatBadge(
                        icon: driver.has_driving_licence == 1 ? "checkmark.circle.fill" : "xmark.circle.fill",
                        text: "Permis",
                        color: driver.has_driving_licence == 1 ? .green : .red
                    )
                }
                
                // Description
                Text(driver.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                // Bouton Ajouter au panier
                Button(action: {
                    // Action d'ajout au panier à implémenter
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Ajouter au panier")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#28AFB0"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5)
    }
}

struct StatBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
                .font(.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    DriversView()
}

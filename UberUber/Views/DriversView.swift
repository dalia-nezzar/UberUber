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



#Preview {
    DriversView()
}

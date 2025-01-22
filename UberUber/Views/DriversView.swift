//
//  ContentView.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

struct DriversView: View {
    @EnvironmentObject private var driverViewModel: DriverViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var selectedFilter: DriverFilter = .all
    @State private var applyUserPreferences: Bool = false
    
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
        guard case .successes(let drivers) = driverViewModel.state else { return [] }
        
        // First apply user preferences if enabled
        let preferencesFiltered = applyUserPreferences ? drivers.filter { driver in
            guard case .success(let user) = userViewModel.state else { return true }
            
            // Apply criminal record preference
            if user.allow_criminal_record == 1 && driver.has_criminal_record == 1 {
                return false
            }
            
            // Add other user preferences here if needed
            
            return true
        } : drivers
        
        // Then apply the selected category filter
        switch selectedFilter {
        case .all:
            return preferencesFiltered
        case .safest:
            return preferencesFiltered.sorted { $0.days_since_last_accident > $1.days_since_last_accident }
        case .cheapest:
            return preferencesFiltered.sorted { $0.price < $1.price }
        case .newest:
            return preferencesFiltered.sorted { $0.created_at > $1.created_at }
        }
    }
    
    var body: some View {
        NavigationStack {
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
                    // Category filters
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
                    
                    // User preferences toggle
                    HStack {
                        Toggle(isOn: $applyUserPreferences) {
                            Label("Appliquer les préférences personnelles", systemImage: "person.fill")
                                .font(.subheadline)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#28AFB0")))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    
                    // Liste des conducteurs
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                            switch driverViewModel.state {
                            case .notAvailable, .loading:
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .frame(maxWidth: .infinity, minHeight: 300)
                            case .successes:
                                ForEach(filteredDrivers, id: \.id_driver) { driver in
                                    NavigationLink(value: driver) {
                                        DriverCard(driver: driver)
                                    }
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
                        .animation(.spring(), value: applyUserPreferences)
                    }
                }
            }
            .navigationDestination(for: Driver.self) { driver in
                SingleDriverView(driver: driver)
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
                await driverViewModel.getDrivers()
            }
        }
    }
}

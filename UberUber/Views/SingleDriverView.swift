//
//  Product.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

struct SingleDriverView: View {
    let driver: Driver
    @EnvironmentObject var driverViewModel: DriverViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showAddedToCartAlert = false
    @State private var showDetails = false

    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: driver.image_url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea(.all)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    // Overlay gradient
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.5), .clear]),
                        startPoint: .top,
                        endPoint: .center
                    )
                    .frame(height: 300)
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.5)))
                            .padding()
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Informations principales
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(driver.firstname) \(driver.lastname)")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(String(format: "%.2f €", Double(driver.price) ?? 0))
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        // Badge de sécurité amélioré
                        SafetyBadge(days: driver.days_since_last_accident)
                    }
                    
                    // Statistiques importantes
                    VStack(spacing: 12) {
                        StatRow(
                            icon: driver.has_driving_licence == 1 ? "checkmark.circle.fill" : "xmark.circle.fill",
                            title: "Permis de conduire",
                            value: driver.has_driving_licence == 1 ? "Valide" : "Non valide",
                            color: driver.has_driving_licence == 1 ? .green : .red
                        )
                        
                        StatRow(
                            icon: driver.has_criminal_record == 0 ? "shield.checkerboard" : "exclamationmark.triangle.fill",
                            title: "Casier judiciaire",
                            value: driver.has_criminal_record == 0 ? "Clean" : "À vérifier",
                            color: driver.has_criminal_record == 0 ? .green : .orange
                        )
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("À propos")
                            .font(.headline)
                        
                        Text(driver.description)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    // Bouton d'ajout au panier amélioré
                    Button(action: {
                        Task {
                            if case .success(let user) = userViewModel.state {
                                await cartViewModel.addDriverToCart(client_id: user.id_client, driver_id: driver.id_driver)
                                showAddedToCartAlert = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Réserver ce conducteur")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#28AFB0"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
        }
        .alert("Réservation ajoutée au panier", isPresented: $showAddedToCartAlert) {
            Button("Super !", role: .cancel) { }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showDetails = true
            }
        }
    }
}

struct SafetyBadge: View {
    let days: Int

    var badgeColor: Color {
        switch days {
        case 100...:
            return .green
        case 50..<100:
            return .orange
        default:
            return .red
        }
    }

    var body: some View {
        VStack {
            Image(systemName: "shield.checkered")
                .font(.title)
                .foregroundColor(badgeColor)
            Text("\(days) jours")
                .font(.caption)
                .bold()
            Text("sans accident")
                .font(.caption)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(badgeColor.opacity(0.2))
        )
    }
}


struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

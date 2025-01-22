//
//  DriverCard.swift
//  UberUber
//
//  Created by nezzar dalia on 21/01/2025.
//

import SwiftUI

struct DriverCard: View {
    let driver: Driver
    
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showAddedToCartAlert = false


    
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
                    
                    StatBadge(
                        icon: driver.has_criminal_record == 1 ? "exclamationmark.shield.fill" : "checkmark.shield.fill",
                        text: driver.has_criminal_record == 1 ? "Casier" : "Clean",
                        color: driver.has_criminal_record == 1 ? .red: .green
                    )
                }
                
                // Description
                Text(driver.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                // Bouton Ajouter au panier
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
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5)
        .alert("Ajouté au panier", isPresented: $showAddedToCartAlert) {
                    Button("OK", role: .cancel) { }
                }
    }
}


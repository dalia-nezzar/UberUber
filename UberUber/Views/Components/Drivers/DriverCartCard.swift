//
//  DriverCartCard.swift
//  UberUber
//
//  Created by nezzar dalia on 21/01/2025.
//

import SwiftUI

struct DriverCartCard: View {
    let driver: Driver
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            AsyncImage(url: driver.image_url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundColor(Color(hex: "#19647E").opacity(0.3))
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Informations
            VStack(alignment: .leading, spacing: 8) {
                // Nom et Prénom
                Text("\(driver.firstname) \(driver.lastname)")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#19647E"))
                
                // Prix
                Text(driver.price + "€")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#28AFB0"))
                    .fontWeight(.bold)
                
                // Statistiques
                HStack(spacing: 8) {
                    // Jours depuis dernier accident
                    HStack(spacing: 4) {
                        Image(systemName: "car.fill")
                            .foregroundColor(driver.days_since_last_accident > 365 ? .green : .orange)
                        Text("\(driver.days_since_last_accident)j")
                            .font(.caption)
                    }
                    
                    // Permis
                    HStack(spacing: 4) {
                        Image(systemName: driver.has_driving_licence == 1 ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(driver.has_driving_licence == 1 ? .green : .red)
                        Text("Permis")
                            .font(.caption)
                    }
                    
                    // Casier judiciaire
                    HStack(spacing: 4) {
                        Image(systemName: driver.has_criminal_record == 1 ? "exclamationmark.triangle.fill" : "checkmark.shield.fill")
                            .foregroundColor(driver.has_criminal_record == 1 ? .red : .green)
                        Text(driver.has_criminal_record == 1 ? "Casier" : "Clean")
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

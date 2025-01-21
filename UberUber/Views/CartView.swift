//
//  Cart.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationView {
            Group {
                switch cartViewModel.state {
                case .loading:
                    ProgressView("Chargement...")
                case .successes(let drivers):
                    if drivers.isEmpty {
                        Text("Votre panier est vide")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(drivers, id: \.id) { driver in
                                    DriverCartCard(driver: driver)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            if case .success(let user) = userViewModel.state {
                                                Button(role: .destructive) {
                                                    Task {
                                                        await cartViewModel.deleteDriverFromCart(
                                                            client_id: user.id_client,
                                                            driver_id: driver.id_driver
                                                        )
                                                    }
                                                } label: {
                                                    Label("Supprimer", systemImage: "trash")
                                                }
                                                .tint(.red)
                                            }
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                case .failed(let error):
                    Text("Erreur : \(error.localizedDescription)")
                case .notAvailable:
                    Text("Panier non disponible")
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Mon Panier")
        }
    }
}

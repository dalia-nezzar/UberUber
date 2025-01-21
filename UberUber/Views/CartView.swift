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
                    
                    Group {
                        switch cartViewModel.state {
                        case .loading:
                            ProgressView("Une petite seconde...")
                        case .successes(let drivers):
                            if drivers.isEmpty {
                                Text("Ton panier est vide")
                                    .foregroundColor(.white)
                            } else {
                                List {
                                    ForEach(drivers, id: \.id_driver) { driver in
                                        DriverCartCard(driver: driver)
                                            .listRowSeparator(.hidden)
                                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                    }
                                    .onDelete { indexSet in
                                        if case .success(let user) = userViewModel.state,
                                           let index = indexSet.first {
                                            let driver = drivers[index]
                                            Task {
                                                await cartViewModel.deleteDriverFromCart(
                                                    client_id: user.id_client,
                                                    driver_id: driver.id_driver
                                                )
                                            }
                                        }
                                    }
                                }
                                .listStyle(.plain)
                            }
                        case .failed(let error):
                            Text("Erreur : \(error.localizedDescription)")
                        case .notAvailable:
                            Text("Panier non disponible")
                        default:
                            EmptyView()
                        }
                    }
                }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Color.white
                            .frame(width: 800, height: 155)
                        
                        Image("TonPanier")
                            .resizable()
                            .scaledToFit()
                            .padding(.trailing, 215)
                            .frame(height: 25)
                    }
                    .ignoresSafeArea(.all)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

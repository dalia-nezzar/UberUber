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
    @StateObject var deliveryViewModel = DeliveryViewModel(service: APIService())
    @State private var showingConfirmation = false
    @State private var selectedTab = 1  // Pour gérer la navigation vers DeliveryView
    
    private var totalPrice: Double {
        if case .successes(let drivers) = cartViewModel.state {
            return drivers.reduce(0) { $0 + (Double($1.price) ?? 0) }
        }
        return 0
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
                
                VStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 60)
                    
                    Group {
                        switch cartViewModel.state {
                        case .loading:
                            ProgressView("Une petite seconde...")
                        case .successes(let drivers):
                            if drivers.isEmpty {
                                Text("Ton panier est vide")
                                    .foregroundColor(.white)
                            } else {
                                VStack {
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
                                        .listRowBackground(Color.clear)
                                    }
                                    .listStyle(.plain)
                                    
                                    Spacer()
                                    
                                    VStack(spacing: 16) {
                                        Text("Prix total: \(totalPrice, specifier: "%.2f") €")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "#28AFB0"))
                                        
                                        Button(action: {
                                            if case .success(let user) = userViewModel.state {
                                                Task {
                                                    await deliveryViewModel.orderFromCart(client_id: user.id_client)
                                                    await cartViewModel.getCart(client_id: user.id_client) // Rafraîchit le panier
                                                    showingConfirmation = true // Affiche le popup
                                                }
                                            }
                                        }) {
                                            Text("Commander")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(hex: "1C1C1D"), Color(hex: "#19647E")]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .cornerRadius(12)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal)
                                        .disabled(drivers.isEmpty)
                                    }
                                    .padding()
                                    .background(                
                                        LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "FFFFFF"),
                                            Color(hex: "FFFFFF").opacity(0.5)
                                        ]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    ))
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
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        ZStack {
                            Color.white
                                .frame(width: 800, height: 150)
                            
                            Image("TonPanier")
                                .resizable()
                                .scaledToFit()
                                .padding(.trailing, 215)
                                .frame(height: 25)
                        }
                        .ignoresSafeArea(.all)
                    }
                }
                .alert("Merci de ta réservation !", isPresented: $showingConfirmation) {
                    Button("OK") {
                        NotificationCenter.default.post(
                            name: NSNotification.Name("SwitchToDeliveryView"),
                            object: nil
                        )
                    }
                }
                .task {
                    if case .success(let user) = userViewModel.state {
                        await cartViewModel.getCart(client_id: user.id_client)
                    }
                }
            }
        }
    }
}

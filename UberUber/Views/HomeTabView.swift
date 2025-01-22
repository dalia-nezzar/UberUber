//
//  TabView.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

struct HomeTabView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    
    @State private var selectedTab = 0

    
    var body: some View {
        TabView(selection: $selectedTab) {
            DriversView()
                .tabItem {
                    Label("Accueil", systemImage: "house")
                }
                .tag(0)
            
            CartView()
                .tabItem {
                    Label("Panier", systemImage: "cart.fill")
                }
                .tag(1)
            
            DeliveryView()
                .tabItem {
                    Label("Réservation", systemImage: "car.fill")
                }
                .tag(2)
            
            AccountView()
                .tabItem {
                    Label("Mon compte", systemImage: "person.crop.circle.fill")
                }
                .tag(3)
        }
        .accentColor(Color(hex: "#28AFB0"))
        .onAppear {
            if case .success(let user) = userViewModel.state {
                Task {
                    await cartViewModel.getCart(client_id: user.id_client)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToDeliveryView"))) { _ in
            selectedTab = 2
        }
    }
}

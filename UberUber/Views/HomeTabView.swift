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
    
    var body: some View {
        TabView {
            DriversView()
                .tabItem {
                    Label("Accueil", systemImage: "house")
                }
            CartView()
                .tabItem {
                    Label("Panier", systemImage: "cart.fill")
                }
            DeliveryView()
                .tabItem {
                    Label("Mes achats", systemImage: "car.fill")
                }
            AccountView()
                .tabItem {
                    Label("Mon compte", systemImage: "person.crop.circle.fill")
                }
        }
        .accentColor(Color(hex: "#28AFB0"))
        .onAppear {
            if case .success(let user) = userViewModel.state {
                Task {
                    await cartViewModel.getCart(client_id: user.id_client)
                }
            }
        }
    }
}

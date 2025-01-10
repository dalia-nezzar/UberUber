//
//  WelcomeView.swift
//  UberUber
//
//  Created by nezzar dalia on 10/01/2025.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showLogin = false

    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#19647E"),
                    Color(hex: "#28AFB0"),
                    Color(hex: "#DDCECD")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            AnimatedWaves()
                .ignoresSafeArea()
            
                        
            VStack {
                Image("LogoNoText")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 650)
                    .padding(.bottom, 5)
                
                Image("LogoText")
                
                
                
                Button(action: {
                    showLogin = true
                }) {
                    Text("Entrer dans UberUber")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                        )
                        .foregroundStyle(Color(hex: "#28AFB0"))
                }
                .padding(.vertical, 80)
            }
        }
        .navigationDestination(isPresented: $showLogin) {
            LoginView()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    WelcomeView()
}

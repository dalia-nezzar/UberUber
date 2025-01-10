//
//  ContentView.swift
//  UberUber
//
//  Created by nezzar dalia on 08/01/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    
    var body: some View {
        Group {
            switch userViewModel.state {
            case .notAvailable, .failed:
                LoginView()
            case .success:
                HomeTabView()
            case .loading:
                ProgressView("Chargement en cours, veuillez patienter...")
            }
        }
    }
}

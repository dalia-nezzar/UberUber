//
//  UberUberApp.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

@main
struct UberUberApp: App {
    
    @StateObject private var userViewModel = UserViewModel(service: APIService())

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
        }
    }
}

//
//  ErrorBanner.swift
//  UberUber
//
//  Created by nicolas noah on 22/01/2025.
//

import SwiftUI

struct ErrorBanner: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
            Text(message)
                .foregroundColor(.white)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color.red)
        .cornerRadius(8)
        .shadow(radius: 4)
        .frame(width: 290)
    }
}

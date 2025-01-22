//
//  ModernTextField.swift
//  UberUber
//
//  Created by nezzar dalia on 08/01/2025.
//

import SwiftUI

struct ModernTextField: View {
    let placeholder: String
    @Binding var text: String
    let systemImage: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundStyle(.white)
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundStyle(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

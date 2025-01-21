//
//  StatBadge.swift
//  UberUber
//
//  Created by nezzar dalia on 21/01/2025.
//

import SwiftUI

struct StatBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
                .font(.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .foregroundColor(color)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    StatBadge(icon: "", text: "Oui", color: .black)
    
}

#Preview {
    StatBadge(icon: "", text: "Non", color: .blue)
    
}

//
//  DetailRow.swift
//  UberUber
//
//  Created by nezzar dalia on 22/01/2025.
//

import SwiftUI

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    var highlighted: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(highlighted ? .blue : .secondary)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(highlighted ? .semibold : .regular)
        }
    }
}

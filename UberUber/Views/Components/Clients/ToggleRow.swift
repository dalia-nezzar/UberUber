//
//  ToggleRow.swift
//  UberUber
//
//  Created by nezzar dalia on 22/01/2025.
//

import SwiftUI

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(title, isOn: $isOn)
            .disabled(true)
    }
}

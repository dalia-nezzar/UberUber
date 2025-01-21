//
//  AnimatedWave.swift
//  UberUber
//
//  Created by nezzar dalia on 08/01/2025.
//

import SwiftUI


struct AnimatedWaves: View {
    @State private var phase = 0.0

    var body: some View {
        ZStack {
            // Première vague
            Wave(offset: CGFloat(phase), percent: 0.8)
                .fill(Color.white.opacity(0.3))
                .frame(height: UIScreen.main.bounds.height * 1)

            // Deuxième vague
            Wave(offset: CGFloat(phase * 1.5), percent: 0.6)
                .fill(Color.white.opacity(0.1))
                .frame(height: UIScreen.main.bounds.height * 1)
        }
        .onAppear {
            withAnimation(.linear(duration: 80).repeatForever(autoreverses: false)) {
                phase = UIScreen.main.bounds.width
            }
        }
    }
}


#Preview {
    AnimatedWaves()
}

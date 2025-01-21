//
//  BackgroundWaveShape.swift
//  UberUber
//
//  Created by nezzar dalia on 08/01/2025.
//

import Foundation
import SwiftUI

struct Wave: Shape {
    var offset: CGFloat
    var percent: Double

    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height * CGFloat(percent)
        let wavelength = width / 2 // Longueur d'une onde complète

        path.move(to: CGPoint(x: 0, y: height))

        let extraWidth = wavelength * 6 // Ajouter deux longueurs d'onde pour éviter les trous
        let totalWidth = width + extraWidth

        var x = -extraWidth // Commencez hors écran pour préparer une transition fluide

        while x < totalWidth {
            x += wavelength * 0.25
            path.addCurve(
                to: CGPoint(x: x, y: midHeight),
                control1: CGPoint(x: x - wavelength * 0.3, y: midHeight + 30),
                control2: CGPoint(x: x - wavelength * 0.2, y: midHeight - 30)
            )

            x += wavelength * 0.25
            path.addCurve(
                to: CGPoint(x: x, y: midHeight),
                control1: CGPoint(x: x - wavelength * 0.2, y: midHeight + 30),
                control2: CGPoint(x: x - wavelength * 0.3, y: midHeight - 30)
            )
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))

        return path.offsetBy(dx: offset, dy: 0)
    }
}

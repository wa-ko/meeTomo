//
//  StyledRectangle.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/05/11.
//
import SwiftUI

struct RectangleStyle: ViewModifier {
    var rotationDegrees: Double

    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 500)
            .rotationEffect(Angle.degrees(rotationDegrees))
            .shadow(color: Color.black, radius: 10, x: 0, y: 0)
    }
}

extension View {
    func rectangleStyle(rotationDegrees: Double) -> some View {
        modifier(RectangleStyle(rotationDegrees: rotationDegrees))
    }
}

//
//  TooltipView.swift
//  Utils
//
//  Created by Israel Manzo on 9/13/25.
//

import SwiftUI

struct TooltipView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TooltipView()
}

struct Triangle: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        let topMiddle = CGPoint(x: rect.midX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        path.move(to: bottomLeft)
        path.addLine(to: bottomRight)
        
        path.addArc(
            center: CGPoint(x: topMiddle.x, y: topMiddle.y),
            radius: 0,
            startAngle: .degrees(0),
            endAngle: .degrees(180),
            clockwise: true
        )
        
        path.addLine(to: bottomLeft)
        return path
    }
}

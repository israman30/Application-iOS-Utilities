//
//  TooltipView.swift
//  Utils
//
//  Created by Israel Manzo on 9/13/25.
//

import SwiftUI

struct TooltipView: View {
    var list: [TooltipModel] = [
        TooltipModel(title: "Hello World")
    ]
    
    var list2: [TooltipModel] = [
        TooltipModel(icon: "heart.fill", title: "31")
    ]
    
    var list3: [TooltipModel] = [
        TooltipModel(icon: "bubble.fill", title: "31")
    ]
    
    var body: some View {
        VStack(spacing: 50) {
            Tooltip(items: list, type: .bottom)
            Tooltip(items: list2, type: .top)
            Tooltip(items: list3, type: .left)
            Tooltip(items: list, type: .right)
        }
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

public struct TooltipModel {
    let id = UUID().uuidString
    var icon: String? = nil
    let title: String
}

enum TooltipDirection {
    case top, left, right, bottom
}

public struct Tooltip: View {
    var items: [TooltipModel]
    var type: TooltipDirection
    
    public var body: some View {
        ZStack(alignment: alignment()) {
            HStack(spacing: 8) {
                ForEach(items, id: \.id) { item in
                    ActivityItem(item: item)
                }
            }
            .padding(8)
            .background(Color.red.opacity(0.5))
            .cornerRadius(8)
            
            switch type {
            case .top:
                triangle()
                    .offset(y: -10)
            case .left:
                triangle()
                    .rotationEffect(.degrees(-90))
                    .offset(x: -15)
            case .right:
                triangle()
                    .rotationEffect(.degrees(90))
                    .offset(x: 15)
            case .bottom:
                triangle()
                    .rotationEffect(.degrees(180))
                    .offset(y: 10)
            }
        }
    }
    
    private func ActivityItem(item: TooltipModel) -> some View {
        HStack(spacing: 2) {
            if let icon = item.icon {
                Image(systemName: icon)
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 16, height: 16)
            }
            
            Text(item.title)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(1)
                .foregroundStyle(.white)
        }
    }
    
    private func triangle() -> some View {
        Triangle()
            .fill(Color.red.opacity(0.5))
            .frame(width: 20, height: 10)
    }
    
    private func alignment() -> Alignment {
        switch type {
        case .top:
            return .top
        case .left:
            return .leading
        case .right:
            return .trailing
        case .bottom:
            return .bottom
        }
    }
}


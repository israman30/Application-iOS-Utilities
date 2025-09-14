//
//  TooltipView.swift
//  Utils
//
//  Created by Israel Manzo on 9/13/25.
//

import SwiftUI

struct TooltipView: View {
    
    var body: some View {
        VStack(spacing: 50) {
            ActivityItem("Label")
            
            ActivityItem("Label 2") {
                Image(systemName: "heart.fill")
            }
            
            ActivityItem("12", type: .left) {
                Image(systemName: "bubble.fill")
            }
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

enum TooltipDirection {
    case top, left, right, bottom
}

public struct ActivityItem<Icon: View>: View {
    var title: String
    var type: TooltipDirection = .bottom
    var icon: Icon
    
    init(
        _ title: String,
        type: TooltipDirection = .bottom,
        @ViewBuilder icon: () -> Icon = EmptyView.init
    ) {
        self.title = title
        self.type = type
        self.icon = icon()
    }
    
    public var body: some View {
        ZStack(alignment: alignment) {
            HStack {
                HStack(spacing: 2) {
                    icon
                        .foregroundStyle(.white)
                        .padding(.trailing, 2)
                    
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(1)
                        .foregroundStyle(.white)
                }
                .padding(8)
                .background(Color.red.opacity(0.5))
                .cornerRadius(8)
            }
            
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
    
    private var alignment: Alignment {
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
    
    private func triangle() -> some View {
        Triangle()
            .fill(Color.red.opacity(0.5))
            .frame(width: 20, height: 10)
    }
    
    private func ActivityItem(title: String, icon: String? = nil) -> some View {
        HStack(spacing: 2) {
            if let icon = icon {
                Image(systemName: icon)
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 16, height: 16)
            }
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(1)
                .foregroundStyle(.white)
        }
    }
}


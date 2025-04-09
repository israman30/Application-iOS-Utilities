//
//  FloatingButtonView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI

struct FloatingButtonView: View {
    var body: some View {
        NavigationView {
            ZStack {
                List(0..<50) { item in
                    NavigationLink {
                        
                    } label: {
                        Text("Item \((item + 1))")
                    }
                }
                FloatingButtonUtilsView {
                    // action
                }
            }
        }
    }
}

#Preview {
    FloatingButtonView()
}

/// numerate the `alignments` for the floating button
enum AlignmentFloatingButton {
    case leading
    case trailing
}

/// Custom input `params` for customize the floating button
public struct FloatingButtonUtilsView: View {
    var icon: String = "plus"
    var color: Color = .blue
    var action: () -> Void
    var alignment: AlignmentFloatingButton = .trailing
    
    init(
        alignment: AlignmentFloatingButton = .trailing,
        color: Color = .blue,
        icon: String = "plus",
        action: @escaping () -> Void
    ) {
        self.color = color
        self.icon = icon
        self.action = action
        self.alignment = alignment
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    if alignment == .trailing {
                        Spacer()
                        floatingButton
                    } else {
                        floatingButton
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var floatingButton: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .font(.title.weight(.semibold))
                .padding()
                .background(color)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
        .padding()
    }
}

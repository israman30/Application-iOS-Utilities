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

public struct FloatingButtonUtilsView: View {
    
    var icon: String = "plus"
    var color: Color = .blue
    var action: () -> Void
    
    init(color: Color = .blue, icon: String = "plus", action: @escaping () -> Void) {
        self.color = color
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
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
        }
    }
}

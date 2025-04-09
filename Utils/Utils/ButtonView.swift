//
//  ButtonView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI

struct ButtonView: View {
    var body: some View {
        ButtonViewUtils(label: "Tap here") {
            
        }
    }
}

#Preview {
    ButtonView()
}

public struct ButtonViewUtils: View {
    let label: String
    let icon: String?
    let action: () -> Void
    
    init(label: String, icon: String? = nil, action: @escaping() -> Void) {
        self.label = label
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            if let icon = icon {
                Image(systemName: icon)
            }
            Text(label)
        }
        .buttonStyle(.borderedProminent)
    }
}

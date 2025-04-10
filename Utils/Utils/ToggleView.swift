//
//  ToggleView.swift
//  Utils
//
//  Created by Israel Manzo on 4/10/25.
//

import SwiftUI

struct ToggleView: View {
    @State var isOn = false
    var body: some View {
        ToggleViewUtils(titleKey: "title", isOn: $isOn)
            .padding()
    }
}

#Preview {
    ToggleView()
}

public struct ToggleViewUtils: View {
    var titleKey: LocalizedStringKey = ""
    @Binding var isOn: Bool
    var tintColor: Color? = .blue
    var backgroundColor: Color? = Color.gray.opacity(0.2)
    var cornerRadius: CGFloat = 5
    
    public var body: some View {
        Toggle(titleKey, isOn: $isOn)
            .padding()
            .tint(tintColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

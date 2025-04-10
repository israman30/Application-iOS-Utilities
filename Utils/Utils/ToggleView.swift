//
//  ToggleView.swift
//  Utils
//
//  Created by Israel Manzo on 4/10/25.
//

import SwiftUI

struct ToggleView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ToggleView()
}

public struct ToggleViewUtils: View {
    var titleKey: LocalizedStringKey
    @Binding var isOn: Bool
    
    public var body: some View {
        Toggle(titleKey, isOn: $isOn)
    }
}

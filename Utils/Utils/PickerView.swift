//
//  PickerView.swift
//  Utils
//
//  Created by Israel Manzo on 4/10/25.
//

import SwiftUI

struct PickerView: View {
    @State var selection: String = ""
    let options = ["Car", "Plane", "Boat", "Train"]
    var body: some View {
        VStack {
            PickerViewUtils(titleKey: "Select a transport", selection: $selection, opions: options) {
                // update
            }
        }
        
    }
}

#Preview {
    PickerView()
}

public struct PickerViewUtils<T: Hashable>: View {
    var titleKey: String
    @Binding var selection: T
    var opions: [T]
    
    let onUpdate: (() -> Void)?
    
    public var body: some View {
        Picker(titleKey, selection: $selection) {
            ForEach(opions, id: \.self) { option in
                Text(String(describing: option))
                    .tag(option as T?)
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            onUpdate?()
        }
    }
}

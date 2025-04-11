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
    @State var date = Date.now
    var body: some View {
        VStack {
            PickerViewUtils(titleKey: "Select a transport", selection: $selection, opions: options) {
                // update
            }
            .pickerStyle(.wheel)
            
            DatePickerViewUtils(
                date: $date,
                labelKey: "Select a date",
                label: "this is a custom label",
                alignment: .center
            )
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

public struct DatePickerViewUtils: View {
    @Binding var date: Date
    var labelKey: String = ""
    var label: String = ""
    var alignment: HorizontalAlignment = .leading
    
    public var body: some View {
        VStack(alignment: alignment) {
            DatePicker(labelKey, selection: $date)
            Text(
                "\(String(describing: label)) \(date.formatted(date: .long, time: .omitted))"
            )
            .font(.body)
        }
    }
}

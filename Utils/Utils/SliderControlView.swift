//
//  SliderControlView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI

struct SliderControlView: View {
    @State var value: Double = 50
    var body: some View {
        VStack {
            Text("\(value)")
            SliderControlViewUtils(
                value: $value,
                min: 0,
                max: 100,
                minIcon: "minus.circle.fill",
                maxIcon: "plus.circle.fill"
            ) { _ in
                // update
            } minTapAction: {
                value -= 1
            } maxTapAction: {
                value += 1
            }
            .padding()
        }
    }
}

#Preview {
    SliderControlView()
}


public struct SliderControlViewUtils: View {
    
    var label: String? = nil
    @Binding var value: Double
    var min: Double = 0
    var max: Double = 100
    var minIcon: String? = nil
    var maxIcon: String? = nil
    
    let onUpdate: (() -> Void)? = nil
    var onEditingChanged: ((Bool) -> Void)? = nil
    var minTapAction: (() -> Void)? = nil
    var maxTapAction: (() -> Void)? = nil
    
    init(
        value: Binding<Double>,
        min: Double,
        max: Double,
        minIcon: String? = nil,
        maxIcon: String? = nil,
        minimumValueLabel: String? = nil,
        maximumValueLabel: String? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        minTapAction: (() -> Void)? = nil,
        maxTapAction: (() -> Void)? = nil
    ) {
        self._value = value
        self.min = min
        self.max = max
        self.minIcon = minIcon
        self.maxIcon = maxIcon
        self.onEditingChanged = onEditingChanged
        self.minTapAction = minTapAction
        self.maxTapAction = maxTapAction
    }
    
    public var body: some View {
        HStack {
            if let minIcon {
                Image(systemName: minIcon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        minTapAction?()
                    }
            }
            if let onEditingChanged {
                Slider(
                    value: Binding<Double>(
                        get: {
                            value
                        },
                        set: { newValue in
                            let setValue = Swift.max(Swift.min(newValue, max), min)
                            value = setValue
                            onUpdate?()
                        }
                    ),
                    in: min...max,
                    step: 1,
                    onEditingChanged: onEditingChanged
                ) {
                    if let label {
                        Text(label)
                    }
                }
            }
            if let maxIcon {
                Image(systemName: maxIcon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        maxTapAction?()
                    }
            }
        }
    }
}

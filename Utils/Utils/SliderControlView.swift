//
//  SliderControlView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI

struct SliderControlView: View {
    @State var value = 50
    var body: some View {
        VStack {}

    }
}

#Preview {
    SliderControlView()
}


public struct SliderControlViewUtils: View {
    
    @Binding var value: Double
    var min: Double = 0
    var max: Double = 100
    var label: String? = nil
    var minimumValueLabel: String? = nil
    var maximumValueLabel: String? = nil
    var step: Double = 1
    var didChange: (Bool) -> Void
    
    init(
        value: Binding<Double>,
        min: Double,
        max: Double,
        label: String? = nil,
        minimumValueLabel: String? = nil,
        maximumValueLabel: String? = nil,
        step: Double,
        didChange: @escaping (Bool) -> Void
    ) {
        self._value = value
        self.min = min
        self.max = max
        self.label = label
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.step = step
        self.didChange = didChange
    }
    
    public var body: some View {
        HStack {
            Slider(value: $value, in: min...max, step: step) { didChange in
               
            }
            Slider(value: $value, in: min...max) {
                if let label {
                    Text(label)
                }
            } minimumValueLabel: {
                if let minimumValueLabel {
                    Text(minimumValueLabel)
                }
            } maximumValueLabel: {
                if let maximumValueLabel {
                    Text(maximumValueLabel)
                }
            }
        }
    }
}

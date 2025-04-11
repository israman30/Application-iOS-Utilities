//
//  StepperView.swift
//  Utils
//
//  Created by Israel Manzo on 4/11/25.
//

import SwiftUI

struct StepperView: View {
    @State var value = 0
    var body: some View {
        StepperViewUtils(title: "stepper", value: $value, min: 0, max: 100, step: 1) {
            // update
        }
    }
}

#Preview {
    StepperView()
}

public struct StepperViewUtils: View {
    var title: String = ""
    @Binding var value: Int
    let min: Int
    let max: Int
    let step: Int
    let onUpdate:(() -> Void)?
    
    public var body: some View {
        Stepper(title, value: $value, step: step)
            .onChange(of: value) { _,_ in
                onUpdate?()
            }
    }
}

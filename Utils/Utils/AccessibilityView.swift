//
//  AccessibilityView.swift
//  Utils
//
//  Created by Israel Manzo on 7/5/25.
//

import SwiftUI

// MARK: - Usage View
struct AccessibilityView: View {
    @State var value = 0.1
    
    var body: some View {
        Text("Accessibility View")
            .font(.largeTitle)
            .accessibility(options: [
                .traits([.isHeader]),
                .heading(level: .h1)
            ])
        
        VStack {
            Slider(value: $value)
                .accessibility(options: [
                    .labels("Value Slider"),
                    .value("\(value)"),
                    .hint("Drag to change value"),
                    .behaviour(children: .ignore)
                ])
            Text("\(Int(value))")
        }
        .accessibility(options: [.behaviour(children: .combine)])
    }
}

#Preview {
    AccessibilityView()
}

public enum AccessibilityOption {
    case traits([AccessibilityTraits])
    case labels(_ label: String)
    case value(_ value: String)
    case hint(_ hint: String)
    case accessibilityHidden
    case behaviour(children: AccessibilityChildBehavior)
    case heading(level: AccessibilityHeadingLevel)
}

struct AccessibilityOptionModifier: ViewModifier {
    private let label: String?
    private let value: String?
    private let hint: String?
    private let traits: AccessibilityTraits?
    private let accessibilityHidden: Bool
    private let behaviour: AccessibilityChildBehavior?
    private let heading: AccessibilityHeadingLevel?
    
    public init(options: [AccessibilityOption]) {
        var label: String? = nil
        var value: String? = nil
        var hint: String? = nil
        var combinedTraits = AccessibilityTraits()
        var traitSet = false
        var accessibilityHidden: Bool = false
        var behaviour: AccessibilityChildBehavior? = nil
        var heading: AccessibilityHeadingLevel? = nil
        
        for option in options {
            switch option {
            case .labels(let labelValue):
                label = labelValue
            case .value(let valueValue):
                value = valueValue
            case .hint(let hintValue):
                hint = hintValue
            case .traits(let traitsValue):
                traitSet = true
                let traitsToAdd = traitsValue.reduce(AccessibilityTraits()) { $0.union($1) }
                combinedTraits.formUnion(traitsToAdd)
            case .accessibilityHidden:
                accessibilityHidden = true
            case .behaviour(let behaviourValue):
                behaviour = behaviourValue
            case .heading(let headingLevel):
                heading = headingLevel
            }
        }
        
        self.label = label
        self.value = value
        self.hint = hint
        self.traits = traitSet ? combinedTraits : nil
        self.accessibilityHidden = accessibilityHidden
        self.behaviour = behaviour
        self.heading = heading
        
    }
    
    func body(content: Content) -> some View {
        content
            .modifierIf(behaviour != nil) { $0.accessibilityElement(children: behaviour!) }
            .modifierIf(traits != nil) { $0.accessibilityAddTraits(traits!) }
            .modifierIf(label != nil) { $0.accessibilityLabel(Text(label!)) }
            .modifierIf(value != nil) { $0.accessibilityValue(Text(value!)) }
            .modifierIf(hint != nil) { $0.accessibilityHint(Text(hint!)) }
            .modifierIf(accessibilityHidden) { $0.accessibilityHidden(true) }
            .modifierIf(heading != nil) { $0.accessibilityHeading(heading!) }
    }
}

extension View {
    @ViewBuilder
    public func modifierIf<ModifierdContent: View>(_ condition: Bool, modifer: (Self) -> ModifierdContent) -> some View {
        if condition {
            modifer(self)
        } else {
            self
        }
    }
    
    public func accessibility(options: [AccessibilityOption]) -> some View {
        self.modifier(AccessibilityOptionModifier(options: options))
    }
}

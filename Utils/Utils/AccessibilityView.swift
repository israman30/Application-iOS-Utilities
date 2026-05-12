//
//  AccessibilityView.swift
//  Utils
//
//  Created by Israel Manzo on 7/5/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Accessibility reference screen (demo)
/// A small, copy-pastable reference screen that demonstrates practical SwiftUI accessibility patterns.
///
/// ## Setup
/// - Drop this file into your project (or open this view from a debug/demo menu).
/// - Turn on system accessibility settings (Dynamic Type, VoiceOver, Increase Contrast, etc.)
///   and verify the UI remains readable and navigable.
///
/// ## What it demonstrates
/// - **Typography**: uses semantic text styles so content scales with Dynamic Type.
/// - **Contrast**: uses adaptive system colors and increases borders in higher-contrast modes.
/// - **VoiceOver**: assigns clear labels/values/hints and keeps announcements concise via
///   `.accessibilityElement(children:)`.
/// - **Differentiate Without Color**: shows a status chip that remains understandable without color.
/// - **Reduce Motion / Transparency**: avoids animation when Reduce Motion is enabled and favors
///   system surfaces that remain legible under reduced transparency.
///
/// ## Usage
/// You can use this view as a checklist: compare your production screens against these patterns,
/// then extract the pieces (cards, rows, and accessibility modifiers) that fit your app.
struct AccessibilityView: View {
    @State private var sliderValue: Double = 42
    @State private var isFeatureEnabled: Bool = true
    @State private var quantity: Int = 1
    @State private var showConfirmation: Bool = false
    @State private var status: ConnectionStatus = .connected

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency: Bool
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled: Bool
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast: ColorSchemeContrast
    @Environment(\.legibilityWeight) private var legibilityWeight: LegibilityWeight?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    environmentCard
                    textAndFontCard
                    colorAndContrastCard
                    controlsCard
                }
                .padding()
            }
            .navigationTitle("Accessibility")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(uiColor: .systemBackground))
        }
        .alert("Saved", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your settings were updated.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Accessibility View")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)
                .accessibility(options: [
                    // Keep the top title discoverable as a semantic heading in VoiceOver rotor navigation.
                    .traits([.isHeader]),
                    .heading(level: .h1),
                    .labels("Accessibility")
                ])

            Text("Examples of typography, color/contrast, and VoiceOver-friendly controls.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    private var environmentCard: some View {
        AccessibilityCard(title: "Current accessibility context") {
            VStack(alignment: .leading, spacing: 8) {
                EnvironmentRow(label: "Dynamic Type", value: dynamicTypeSizeDescription)
                EnvironmentRow(label: "Contrast", value: colorSchemeContrast == .increased ? "Increased" : "Standard")
                EnvironmentRow(label: "Legibility", value: legibilityWeight == .bold ? "Bold" : "Regular")
                EnvironmentRow(label: "Differentiate w/o color", value: differentiateWithoutColor ? "On" : "Off")
                EnvironmentRow(label: "Reduce motion", value: reduceMotion ? "On" : "Off")
                EnvironmentRow(label: "Reduce transparency", value: reduceTransparency ? "On" : "Off")
                EnvironmentRow(label: "VoiceOver", value: voiceOverEnabled ? "On" : "Off")
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var textAndFontCard: some View {
        AccessibilityCard(title: "Text & font") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Use text styles (headline/body/caption) so content scales with Dynamic Type.")
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Section title")
                        .font(.headline)
                    Text("Supporting copy that can wrap onto multiple lines at accessibility sizes without truncation.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)

                Divider()

                Text("Numbers")
                    .font(.headline)
                    .accessibility(options: [.heading(level: .h2)])

                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("Order total")
                        .font(.body)
                    Spacer(minLength: 0)
                    Text("$\(quantity * 12).00")
                        .font(.body.weight(.semibold))
                        .monospacedDigit()
                        .foregroundStyle(.primary)
                        // Numbers should be spoken as a human-friendly phrase, not as raw symbols.
                        .accessibilityLabel("Order total")
                        .accessibilityValue("\(quantity * 12) dollars")
                }
            }
        }
    }

    private var colorAndContrastCard: some View {
        AccessibilityCard(title: "Color & contrast") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Avoid meaning-by-color alone. Combine color with text, symbols, or shapes.")
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                ConnectionStatusPill(status: status, differentiateWithoutColor: differentiateWithoutColor)
                    // Expose a single, clean announcement (label + value) for status.
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Connection status")
                    .accessibilityValue(status.accessibilityValue)

                HStack(spacing: 10) {
                    Button {
                        status = .connected
                    } label: {
                        Label("Connected", systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        status = .limited
                    } label: {
                        Label("Limited", systemImage: "exclamationmark.triangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        status = .disconnected
                    } label: {
                        Label("Offline", systemImage: "xmark.octagon")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .labelStyle(.titleAndIcon)
                .font(.subheadline.weight(.semibold))

                Divider()

                Button {
                    showConfirmation = true
                } label: {
                    Label("Save changes", systemImage: "square.and.arrow.down.fill")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityHint("Saves your changes and shows a confirmation.")
            }
        }
    }

    private var controlsCard: some View {
        AccessibilityCard(title: "VoiceOver-friendly controls") {
            VStack(alignment: .leading, spacing: 14) {
                ToggleViewUtils(
                    title: "Enable feature",
                    subtitle: "Improves recommendations and sync.",
                    icon: "sparkles",
                    isOn: $isFeatureEnabled,
                    tintColor: .blue,
                    usesHaptics: true
                )
                .accessibilitySortPriority(3)

                SliderControlViewUtils(
                    titleKey: "Intensity",
                    value: $sliderValue,
                    min: 0,
                    max: 100,
                    step: 1,
                    minIcon: "minus",
                    maxIcon: "plus",
                    minimumValueLabel: "0",
                    maximumValueLabel: "100",
                    showsValue: true,
                    tintColor: .blue,
                    backgroundColor: .clear
                )
                .accessibilitySortPriority(2)

                Stepper(value: $quantity, in: 1...10, step: 1) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Quantity")
                            .font(.headline)
                        Text("Current: \(quantity)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
                // Stepper defaults are decent, but a custom value/hint makes it clearer when embedded in cards.
                .accessibilityLabel("Quantity")
                .accessibilityValue("\(quantity)")
                .accessibilityHint("Adjusts the quantity from one to ten.")
                .accessibilitySortPriority(1)

                Button {
                    // Respect Reduce Motion by removing animation.
                    let animation = reduceMotion ? nil : Animation.snappy(duration: 0.22)
                    withAnimation(animation) {
                        showConfirmation = true
                    }
                } label: {
                    Label("Test confirmation", systemImage: "bell.badge.fill")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                .accessibilityHint("Opens a confirmation alert.")
            }
        }
    }

    private var dynamicTypeSizeDescription: String {
        switch dynamicTypeSize {
        case .xSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .xLarge: return "XL"
        case .xxLarge: return "XXL"
        case .xxxLarge: return "XXXL"
        case .accessibility1: return "AX 1"
        case .accessibility2: return "AX 2"
        case .accessibility3: return "AX 3"
        case .accessibility4: return "AX 4"
        case .accessibility5: return "AX 5"
        @unknown default: return "Unknown"
        }
    }
}

#if DEBUG
struct AccessibilityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccessibilityView()
                .previewDisplayName("Light")

            AccessibilityView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark")

            AccessibilityView()
                .dynamicTypeSize(.accessibility5)
                .previewDisplayName("AX XXXL")
        }
    }
}
#endif

private enum ConnectionStatus: String, CaseIterable {
    case connected
    case limited
    case disconnected

    var title: String {
        switch self {
        case .connected: return "Connected"
        case .limited: return "Limited"
        case .disconnected: return "Offline"
        }
    }

    var symbolName: String {
        switch self {
        case .connected: return "checkmark.circle.fill"
        case .limited: return "exclamationmark.triangle.fill"
        case .disconnected: return "xmark.octagon.fill"
        }
    }

    var tint: Color {
        switch self {
        case .connected: return .green
        case .limited: return .orange
        case .disconnected: return .red
        }
    }

    var accessibilityValue: String {
        switch self {
        case .connected: return "Connected"
        case .limited: return "Limited connectivity"
        case .disconnected: return "Offline"
        }
    }
}

/// A compact “status” surface that remains understandable under:
/// - **Increase Contrast** (stronger border)
/// - **Differentiate Without Color** (adds an additional non-color cue)
///
/// The parent view should usually expose this as a single accessibility element.
private struct ConnectionStatusPill: View {
    let status: ConnectionStatus
    let differentiateWithoutColor: Bool

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency: Bool
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast: ColorSchemeContrast

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: status.symbolName)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(status.tint)
                .accessibilityHidden(true)

            Text(status.title)
                .font(.headline)
                .foregroundStyle(.primary)

            if differentiateWithoutColor {
                Text("Status")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.primary.opacity(0.08)))
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(backgroundFill)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(borderColor, lineWidth: colorSchemeContrast == .increased ? 2 : 1)
        }
    }

    private var backgroundFill: Color {
#if canImport(UIKit)
        if reduceTransparency {
            return Color(uiColor: .secondarySystemBackground)
        }
        // Prefer system surfaces so the OS can adapt contrast/legibility appropriately.
        return Color(uiColor: .secondarySystemBackground)
#else
        return Color.primary.opacity(0.06)
#endif
    }

    private var borderColor: Color {
        Color.primary.opacity(colorSchemeContrast == .increased ? 0.28 : 0.16)
    }
}

private struct AccessibilityCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    @Environment(\.colorSchemeContrast) private var colorSchemeContrast: ColorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .accessibility(options: [
                    // Give each card a rotor-navigable section heading.
                    .traits([.isHeader]),
                    .heading(level: .h2)
                ])

            content
        }
        .padding(14)
        .background(backgroundFill)
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.primary.opacity(colorSchemeContrast == .increased ? 0.22 : 0.12), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .contain)
    }

    private var backgroundFill: Color {
#if canImport(UIKit)
        if reduceTransparency {
            return Color(uiColor: .secondarySystemBackground)
        }
        return Color(uiColor: .secondarySystemBackground)
#else
        return Color.primary.opacity(0.06)
#endif
    }
}

private struct EnvironmentRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer(minLength: 0)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(.primary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(value)
    }
}

// MARK: - Accessibility utility: apply multiple modifiers in one call
/// A small set of options used by `.accessibility(options:)`.
///
/// ## Intent
/// SwiftUI’s accessibility API is composed of many individual modifiers. This wrapper lets callers
/// apply a consistent set of label/value/hint/traits/heading behavior in one place, which is useful
/// for reusable UI components.
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
    
    /// Applies multiple accessibility-related modifiers in a single call.
    ///
    /// ## Usage
    /// ```swift
    /// Text("Main Heading")
    ///   .accessibility(options: [
    ///     .traits([.isHeader]),
    ///     .heading(level: .h1),
    ///     .labels("Main heading")
    ///   ])
    /// ```
    ///
    /// Notes:
    /// - Prefer `.behaviour(children:)` to keep VoiceOver announcements concise (`.combine` is often best).
    /// - Use `.labels`, `.value`, and `.hint` to make custom controls predictable for screen reader users.
    public func accessibility(options: [AccessibilityOption]) -> some View {
        self.modifier(AccessibilityOptionModifier(options: options))
    }
}

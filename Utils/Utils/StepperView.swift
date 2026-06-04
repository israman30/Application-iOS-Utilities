//
//  StepperView.swift
//  Utils
//
//  Created by Israel Manzo on 4/11/25.
//

import SwiftUI

// MARK: - Demo / usage
struct StepperView: View {
    @State private var value = 2
    @State private var lastEvent: String = "No updates yet"

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Stepper")
                .font(.title2.weight(.semibold))

            Text("Value: \(value)")
                .font(.footnote.weight(.medium))
                .monospacedDigit()
                .foregroundStyle(.secondary)
                .accessibilityLabel("Current value")
                .accessibilityValue("\(value)")

            StepperViewUtils(title: "Quantity", value: $value, min: 0, max: 100, step: 1, onUpdate: {
                lastEvent = "Updated to \(value)"
            })

            Text(lastEvent)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Last event")
                .accessibilityValue(lastEvent)
        }
        .padding()
    }
}

#if DEBUG
struct StepperView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StepperView()
                .previewDisplayName("Light")

            StepperView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark")

            StepperView()
                .dynamicTypeSize(.accessibility5)
                .previewDisplayName("AX XXXL")
        }
    }
}
#endif

// MARK: - Public component
/// A modern, quantity-style stepper control.
///
/// Unlike SwiftUI’s built-in `Stepper` row, `StepperViewUtils` renders as a compact
/// “pill” control with +/- buttons and an optional live value readout. This design
/// improves tap-target clarity, works well in settings forms, and provides more
/// predictable min/max behavior for integer quantities.
///
/// Accessibility:
/// - VoiceOver reads the current value and a range hint.
/// - +/- buttons expose explicit Increase/Decrease labels and step hints.
public struct StepperViewUtils: View {
    private let titleKey: LocalizedStringKey?
    @Binding private var value: Int

    private let min: Int
    private let max: Int
    private let step: Int

    private let showsValue: Bool
    private let valueText: (Int) -> String

    private let tintColor: Color?
    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    private let onUpdate: (() -> Void)?
    
    static func normalizedBounds(min: Int, max: Int) -> (min: Int, max: Int) {
        (Swift.min(min, max), Swift.max(min, max))
    }
    
    static func normalizedStep(_ step: Int) -> Int {
        // Avoid surprising “no-op” steppers if the call site passes 0 or a negative step.
        step > 0 ? step : 1
    }
    
    static func clampedValue(_ value: Int, min: Int, max: Int) -> Int {
        Swift.max(Swift.min(value, max), min)
    }
    
    static func decrementValue(current: Int, min: Int, max: Int, step: Int) -> Int {
        let step = normalizedStep(step)
        let next = Swift.max(current - step, min)
        return clampedValue(next, min: min, max: max)
    }
    
    static func incrementValue(current: Int, min: Int, max: Int, step: Int) -> Int {
        let step = normalizedStep(step)
        let next = Swift.min(current + step, max)
        return clampedValue(next, min: min, max: max)
    }

    /// Creates a modern stepper control suitable for settings and quantity pickers.
    ///
    /// - Parameters:
    ///   - title: Optional title shown on the leading edge.
    ///   - value: The bound integer value.
    ///   - min: Lower bound. If `min > max`, bounds are normalized.
    ///   - max: Upper bound. If `min > max`, bounds are normalized.
    ///   - step: Increment/decrement step size. Non-positive values are treated as `1`.
    ///   - showsValue: Whether to show the live value in the pill control.
    ///   - valueText: Converts the current value into a display string (shown in the UI and used by accessibility).
    ///   - tintColor: Optional tint for the +/- icons.
    ///   - backgroundColor: Card background for contrast in light/dark mode.
    ///   - cornerRadius: Card corner radius.
    ///   - onUpdate: Called whenever `value` changes (via buttons or external updates).
    public init(
        title: String = "",
        value: Binding<Int>,
        min: Int,
        max: Int,
        step: Int = 1,
        showsValue: Bool = true,
        valueText: @escaping (Int) -> String = { "\($0)" },
        tintColor: Color? = nil,
        backgroundColor: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = 12,
        onUpdate: (() -> Void)? = nil
    ) {
        let bounds = Self.normalizedBounds(min: min, max: max)
        self.titleKey = title.isEmpty ? nil : LocalizedStringKey(title)
        self._value = value
        // Normalize bounds so behavior is deterministic even if call sites pass reversed values.
        self.min = bounds.min
        self.max = bounds.max
        self.step = Self.normalizedStep(step)
        self.showsValue = showsValue
        self.valueText = valueText
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.onUpdate = onUpdate
    }

    /// Creates a stepper control using a localized title key.
    public init(
        titleKey: LocalizedStringKey?,
        value: Binding<Int>,
        min: Int,
        max: Int,
        step: Int = 1,
        showsValue: Bool = true,
        valueText: @escaping (Int) -> String = { "\($0)" },
        tintColor: Color? = nil,
        backgroundColor: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = 12,
        onUpdate: (() -> Void)? = nil
    ) {
        let bounds = Self.normalizedBounds(min: min, max: max)
        self.titleKey = titleKey
        self._value = value
        // Normalize bounds so behavior is deterministic even if call sites pass reversed values.
        self.min = bounds.min
        self.max = bounds.max
        self.step = Self.normalizedStep(step)
        self.showsValue = showsValue
        self.valueText = valueText
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.onUpdate = onUpdate
    }
    
    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            if let titleKey {
                Text(titleKey)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)

            if !showsValue {
                Text(valueText(value))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }

            stepperPill
        }
        .padding(12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .tint(tintColor)
        .onAppear { clampIfNeeded() }
        .onChange(of: value) { _, _ in
            // If the value is out-of-bounds (e.g. from external writes), clamp it without
            // calling `onUpdate` to avoid double-firing side effects.
            if clampIfNeeded() { return }
            onUpdate?()
        }
        .accessibilityElement(children: .contain)
        .accessibilityValue(valueText(value))
        .accessibilityHint("Range \(valueText(min)) to \(valueText(max))")
    }

    private var stepperPill: some View {
        HStack(spacing: 8) {
            decrementButton

            if showsValue {
                Text(valueText(value))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(minWidth: 34)
                    .accessibilityHidden(true)
            }

            incrementButton
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(pillBackground)
        .overlay(pillBorder)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var decrementButton: some View {
        Button {
            let oldValue = value
            value = Self.decrementValue(current: value, min: min, max: max, step: step)
            if value != oldValue { Haptics.selectionChanged() }
        } label: {
            let iconColor: Color = (value <= min) ? .secondary : (tintColor ?? .accentColor)
            Image(systemName: "minus")
                .font(.system(size: 16, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(iconColor)
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(value <= min)
        .accessibilityLabel("Decrease")
        .accessibilityHint("Decreases by \(valueText(step))")
    }

    private var incrementButton: some View {
        Button {
            let oldValue = value
            value = Self.incrementValue(current: value, min: min, max: max, step: step)
            if value != oldValue { Haptics.selectionChanged() }
        } label: {
            let iconColor: Color = (value >= max) ? .secondary : (tintColor ?? .accentColor)
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(iconColor)
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(value >= max)
        .accessibilityLabel("Increase")
        .accessibilityHint("Increases by \(valueText(step))")
    }

    private var pillBackground: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(Color.primary.opacity(0.05))
    }

    private var pillBorder: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .strokeBorder(Color.primary.opacity(0.12), lineWidth: 1)
    }

    @discardableResult
    private func clampIfNeeded() -> Bool {
        let clampedValue = Self.clampedValue(value, min: min, max: max)
        guard clampedValue != value else { return false }
        value = clampedValue
        return true
    }

    private func clamped(_ input: Int) -> Int {
        Self.clampedValue(input, min: min, max: max)
    }
}

private enum Haptics {
    static func selectionChanged() {
#if canImport(UIKit)
        // Keep the file usable in contexts without UIKit availability.
        UISelectionFeedbackGenerator().selectionChanged()
#endif
    }
}

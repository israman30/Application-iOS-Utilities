//
//  SliderControlView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import Foundation
import SwiftUI

struct SliderControlView: View {
    @State var value: Double = 50
    var body: some View {
        VStack(spacing: 16) {
            Text("Value: \(Int(value))")
                .font(.title3.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(.primary)

            SliderControlViewUtils(
                titleKey: "Brightness",
                value: $value,
                min: 0,
                max: 100,
                step: 1,
                minIcon: "minus",
                maxIcon: "plus",
                minimumValueLabel: "0",
                maximumValueLabel: "100",
                showsValue: true,
                tintColor: .blue
            )
        }
        .padding()
    }
}

#if DEBUG
struct SliderControlView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SliderControlView()
                .previewDisplayName("Light")

            SliderControlView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark")

            SliderControlView()
                .dynamicTypeSize(.accessibility5)
                .previewDisplayName("AX XXXL")
        }
    }
}
#endif


/// A settings-style slider with optional +/- controls.
///
/// Use this when you want a `Slider` that:
/// - Shows an optional title and a live value readout
/// - Supports optional increment/decrement buttons with large hit targets
/// - Clamps values safely to the provided bounds
/// - Works well with Dynamic Type and accessibility (VoiceOver reads the value)
///
/// Tip: prefer simple SF Symbols like `minus` / `plus` for the buttons, since this control
/// already provides its own circular button background.
public struct SliderControlViewUtils: View {

    private let titleKey: LocalizedStringKey?
    @Binding private var value: Double

    private let min: Double
    private let max: Double
    private let step: Double

    private let minIcon: String?
    private let maxIcon: String?

    private let minimumValueLabel: String?
    private let maximumValueLabel: String?

    private let showsValue: Bool
    private let valueText: (Double) -> String

    private let tintColor: Color?
    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    private let onUpdate: (() -> Void)?
    private let onEditingChanged: ((Bool) -> Void)?
    private let minTapAction: (() -> Void)?
    private let maxTapAction: (() -> Void)?
    
    static func normalizedBounds(min: Double, max: Double) -> (min: Double, max: Double) {
        (Swift.min(min, max), Swift.max(min, max))
    }
    
    static func clampedValue(_ value: Double, min: Double, max: Double) -> Double {
        Swift.max(Swift.min(value, max), min)
    }
    
    @usableFromInline static func defaultValueText(_ value: Double) -> String {
        if value.rounded(.towardZero) == value {
            return "\(Int(value))"
        }
        return String(format: "%.2f", value)
    }
    
    static func decrementValue(current: Double, min: Double, max: Double, step: Double) -> Double {
        let next = Swift.max(current - step, min)
        return clampedValue(next, min: min, max: max)
    }
    
    static func incrementValue(current: Double, min: Double, max: Double, step: Double) -> Double {
        let next = Swift.min(current + step, max)
        return clampedValue(next, min: min, max: max)
    }
    
    /// Creates a slider control view.
    /// - Parameters:
    ///   - titleKey: Optional title shown above the slider.
    ///   - value: The current value binding.
    ///   - min: Lower bound. If `min > max`, bounds are normalized.
    ///   - max: Upper bound. If `min > max`, bounds are normalized.
    ///   - step: Step size for the slider and default +/- behavior.
    ///   - minIcon: Optional SF Symbol for the decrement button.
    ///   - maxIcon: Optional SF Symbol for the increment button.
    ///   - minimumValueLabel: Optional label shown at the minimum end of the slider.
    ///   - maximumValueLabel: Optional label shown at the maximum end of the slider.
    ///   - showsValue: Whether to show a live value readout in the header.
    ///   - valueText: Converts `value` (and `step`) to a displayable string. Used for the
    ///     header readout and accessibility.
    ///   - tintColor: Optional tint applied to the slider accent.
    ///   - backgroundColor: Card background for contrast in light/dark mode.
    ///   - cornerRadius: Card corner radius.
    ///   - onUpdate: Called whenever `value` changes (via slider or buttons).
    ///   - onEditingChanged: Optional callback invoked when the user begins/ends sliding.
    ///   - minTapAction: Optional custom action when tapping the decrement button.
    ///   - maxTapAction: Optional custom action when tapping the increment button.
    public init(
        titleKey: LocalizedStringKey? = nil,
        value: Binding<Double>,
        min: Double,
        max: Double,
        step: Double = 1,
        minIcon: String? = nil,
        maxIcon: String? = nil,
        minimumValueLabel: String? = nil,
        maximumValueLabel: String? = nil,
        showsValue: Bool = false,
        valueText: @escaping (Double) -> String = {
            value in Self.defaultValueText(value)
        },
        tintColor: Color? = nil,
        backgroundColor: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = 12,
        onUpdate: (() -> Void)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        minTapAction: (() -> Void)? = nil,
        maxTapAction: (() -> Void)? = nil
    ) {
        self.titleKey = titleKey
        self._value = value
        // Normalize bounds to keep behavior predictable even if call sites pass reversed values.
        let bounds = Self.normalizedBounds(min: min, max: max)
        self.min = bounds.min
        self.max = bounds.max
        self.step = step
        self.minIcon = minIcon
        self.maxIcon = maxIcon
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.showsValue = showsValue
        self.valueText = valueText
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.onUpdate = onUpdate
        self.onEditingChanged = onEditingChanged
        self.minTapAction = minTapAction
        self.maxTapAction = maxTapAction
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            HStack(spacing: 12) {
                if minIcon != nil {
                    decrementButton
                }

                slider

                if maxIcon != nil {
                    incrementButton
                }
            }
        }
        .padding(12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .tint(tintColor)
        .onChange(of: value) { _, _ in
            onUpdate?()
        }
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            if let titleKey {
                Text(titleKey)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)

            if showsValue {
                Text(valueText(value))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Value")
                    .accessibilityValue(valueText(value))
            }
        }
    }

    private var slider: some View {
        // Clamp writes so the `Slider`, custom tap actions, and external updates all share
        // the same bounds enforcement.
        let clampedValue = Binding<Double>(
            get: { value },
            set: { newValue in
                value = Self.clampedValue(newValue, min: min, max: max)
            }
        )

        let minLabel = Group {
            if let minimumValueLabel {
                Text(minimumValueLabel)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }

        let maxLabel = Group {
            if let maximumValueLabel {
                Text(maximumValueLabel)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }

        return Group {
            if let onEditingChanged {
                // Use the initializer that includes `onEditingChanged` only when provided.
                Slider(
                    value: clampedValue,
                    in: min...max,
                    step: step,
                    onEditingChanged: onEditingChanged,
                    minimumValueLabel: minLabel,
                    maximumValueLabel: maxLabel
                ) {
                    Group {
                        if let titleKey {
                            Text(titleKey)
                        }
                    }
                }
            } else {
                Slider(
                    value: clampedValue,
                    in: min...max,
                    step: step,
                    minimumValueLabel: minLabel,
                    maximumValueLabel: maxLabel
                ) {
                    Group {
                        if let titleKey {
                            Text(titleKey)
                        }
                    }
                }
            }
        }
        .accessibilityValue(valueText(value))
    }

    private var decrementButton: some View {
        Button {
            let oldValue = value
            if let minTapAction {
                minTapAction()
            } else {
                value = Self.decrementValue(current: value, min: min, max: max, step: step)
            }
            value = Self.clampedValue(value, min: min, max: max)
            if value != oldValue {
                Haptics.selectionChanged()
            }
        } label: {
            Image(systemName: minIcon ?? "minus")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.primary.opacity(0.06)))
        }
        .buttonStyle(.plain)
        .disabled(value <= min)
        .accessibilityLabel("Decrease")
        .accessibilityHint("Decreases by \(valueText(step))")
    }

    private var incrementButton: some View {
        Button {
            let oldValue = value
            if let maxTapAction {
                maxTapAction()
            } else {
                value = Self.incrementValue(current: value, min: min, max: max, step: step)
            }
            value = Self.clampedValue(value, min: min, max: max)
            if value != oldValue {
                Haptics.selectionChanged()
            }
        } label: {
            Image(systemName: maxIcon ?? "plus")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.primary.opacity(0.06)))
        }
        .buttonStyle(.plain)
        .disabled(value >= max)
        .accessibilityLabel("Increase")
        .accessibilityHint("Increases by \(valueText(step))")
    }
}

private enum Haptics {
    static func selectionChanged() {
#if canImport(UIKit)
        // Keep this file platform-flexible (e.g. previews / macCatalyst) without adding
        // a hard UIKit dependency.
        UISelectionFeedbackGenerator().selectionChanged()
#endif
    }
}

//
//  ToggleView.swift
//  Utils
//
//  Created by Israel Manzo on 4/10/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ToggleView: View {
    @State private var isOn = false
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Toggle")
                .font(.title2.weight(.semibold))

            ToggleViewUtils(
                title: "Enable feature",
                subtitle: "Improves recommendations and sync.",
                icon: "sparkles",
                isOn: $isOn,
                tintColor: .blue,
                usesHaptics: true
            )
        }
        .padding()
    }
}

#if DEBUG
struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToggleView()
                .previewDisplayName("Light")

            ToggleView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark")

            ToggleView()
                .dynamicTypeSize(.accessibility4)
                .previewDisplayName("AX XXL")
        }
    }
}
#endif

public struct ToggleViewUtils: View {
    private let titleKey: LocalizedStringKey
    private let subtitle: String?
    private let icon: String?
    @Binding private var isOn: Bool

    private let tintColor: Color?
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let usesHaptics: Bool
    private let onUpdate: ((Bool) -> Void)?

    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor: Bool
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize

    /// A modern “settings row” toggle with better typography, contrast, and accessibility defaults.
    ///
    /// This component is designed to feel at-home in Settings-like screens: it wraps SwiftUI’s
    /// built-in `Toggle` but adds a card surface, optional icon + subtitle, and sensible spacing.
    ///
    /// ## Setup
    /// - Create a `@State` (or `@Binding`) boolean.
    /// - Provide a title, then optionally add `subtitle`, `icon`, and customization parameters.
    ///
    /// ## Usage
    /// ```swift
    /// @State private var isOn = false
    ///
    /// ToggleViewUtils(
    ///     title: "Enable feature",
    ///     subtitle: "Improves recommendations and sync.",
    ///     icon: "sparkles",
    ///     isOn: $isOn,
    ///     tintColor: .blue,
    ///     usesHaptics: true,
    ///     onUpdate: { newValue in
    ///         // Handle value change
    ///     }
    /// )
    /// ```
    ///
    /// ## Implementation notes
    /// - Uses `.secondarySystemBackground` by default for a light/dark adaptive card surface.
    /// - Adds a subtle “on” wash + border so the row has clear affordance without relying only on color.
    /// - Animates state changes with `.snappy` unless **Reduce Motion** is enabled.
    ///
    /// ## Accessibility
    /// - Exposes a single accessibility element (label + `On/Off` value) to keep VoiceOver output clean.
    /// - Uses `subtitle` as an accessibility hint when provided.
    /// - Avoids truncating title/subtitle at accessibility Dynamic Type sizes.
    ///
    /// - Parameters:
    ///   - title: Main label text. Used as the accessibility label.
    ///   - subtitle: Optional supporting text shown below the title (smaller, secondary color).
    ///   - icon: Optional SF Symbol shown leading (e.g. `"bell.badge.fill"`).
    ///   - isOn: Bound toggle state.
    ///   - tintColor: Optional switch tint. If `nil`, uses the environment accent color.
    ///   - backgroundColor: Adaptive card background for light/dark mode.
    ///   - cornerRadius: Card corner radius.
    ///   - usesHaptics: Emits a selection haptic when the value changes.
    ///   - onUpdate: Called whenever `isOn` changes (via user interaction or external writes).
    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isOn: Binding<Bool>,
        tintColor: Color? = nil,
        backgroundColor: Color = Color(uiColor: .secondarySystemBackground),
        cornerRadius: CGFloat = 14,
        usesHaptics: Bool = false,
        onUpdate: ((Bool) -> Void)? = nil
    ) {
        self.titleKey = LocalizedStringKey(title)
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.usesHaptics = usesHaptics
        self.onUpdate = onUpdate
    }

    /// Creates a modern toggle row using a localized title key.
    public init(
        titleKey: LocalizedStringKey,
        subtitle: String? = nil,
        icon: String? = nil,
        isOn: Binding<Bool>,
        tintColor: Color? = nil,
        backgroundColor: Color = Color(uiColor: .secondarySystemBackground),
        cornerRadius: CGFloat = 14,
        usesHaptics: Bool = false,
        onUpdate: ((Bool) -> Void)? = nil
    ) {
        self.titleKey = titleKey
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.usesHaptics = usesHaptics
        self.onUpdate = onUpdate
    }
    
    public var body: some View {
        Toggle(isOn: $isOn) {
            labelView
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .toggleStyle(.switch)
        .tint(tintColor)
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(backgroundView)
        .overlay(borderView)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .frame(minHeight: 44)
        .opacity(isEnabled ? 1 : 0.6)
        .animation(reduceMotion ? nil : .snappy(duration: 0.22), value: isOn)
        .onChange(of: isOn) { _, newValue in
            onUpdate?(newValue)
            if usesHaptics { Haptics.selectionChanged() }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(titleKey))
        .accessibilityValue(Text(isOn ? "On" : "Off"))
        .modifierIf(subtitle?.isEmpty == false) { view in
            view.accessibilityHint(Text(subtitle!))
        }
    }

    private var labelView: some View {
        HStack(alignment: subtitle == nil ? .center : .firstTextBaseline, spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(iconForeground)
                    .frame(width: 26, height: 26)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: subtitle == nil ? 0 : 4) {
                Text(titleKey)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 2)
                    .minimumScaleFactor(0.85)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 3)
                        .minimumScaleFactor(0.85)
                }
            }
        }
    }

    private var iconForeground: Color {
        let base = tintColor ?? .accentColor
        guard isEnabled else { return .secondary }
        // In dark mode, slightly soften the icon so it doesn’t overpower the title.
        if colorScheme == .dark { return base.opacity(0.9) }
        return base
    }

    private var backgroundView: some View {
        ZStack {
            backgroundColor

            // A subtle “selected” wash. This improves perceived affordance without relying solely on color.
            if isOn {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill((tintColor ?? .accentColor).opacity(differentiateWithoutColor ? 0.12 : 0.10))
            }
        }
    }

    private var borderView: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .strokeBorder(Color.primary.opacity(isOn ? 0.16 : 0.12), lineWidth: 1)
    }
}

private enum Haptics {
    static func selectionChanged() {
#if canImport(UIKit)
        UISelectionFeedbackGenerator().selectionChanged()
#endif
    }
}

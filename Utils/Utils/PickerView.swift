//
//  PickerView.swift
//  Utils
//
//  Created by Israel Manzo on 4/10/25.
//

import SwiftUI

// MARK: - Demo / usage
struct PickerView: View {
    @State var selection: String = "Car"
    let options = ["Car", "Plane", "Boat", "Train"]
    @State var date = Date.now
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pickers")
                .font(.title2.weight(.semibold))

            // Default style is controlled by the call site. This wrapper focuses on:
            // - Typography + contrast (works in light/dark)
            // - Optional value readout
            // - Optional haptics + onUpdate callback
            PickerViewUtils(
                titleKey: "Transport",
                selection: $selection,
                options: options,
                showsSelectedValue: true,
                tintColor: .blue
            ) {
                // onUpdate
            }

            // Backwards-compatible initializer (keeps the historical `opions` parameter name).
            PickerViewUtils(titleKey: "Wheel style", selection: $selection, opions: options) {
                // onUpdate
            }
            .pickerStyle(.wheel)

            DatePickerViewUtils(
                labelKey: "Date",
                date: $date,
                valuePrefix: "Selected:",
                displayedComponents: [.date],
                alignment: .leading,
                tintColor: .blue
            )
        }
        .padding()
    }
}

#if DEBUG
struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PickerView()
                .previewDisplayName("Light")

            PickerView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark")

            PickerView()
                .dynamicTypeSize(.accessibility5)
                .previewDisplayName("AX XXXL")
        }
    }
}
#endif

/// A SwiftUI picker wrapper with consistent typography, contrast, and optional haptics.
///
/// Why this exists:
/// - SwiftUI’s `Picker` visuals vary significantly by style (`.menu`, `.wheel`, `.palette`, etc.).
/// - This wrapper standardizes the surrounding “card” treatment (padding/background/corner radius),
///   adds an optional trailing value readout, and wires up accessibility in a predictable way.
///
/// What it intentionally does *not* do:
/// - It does **not** force a `pickerStyle`; call sites can choose the best style for the context.
///
/// Accessibility:
/// - Exposes an accessibility label (when a title is provided).
/// - Exposes an accessibility value equal to the current selection.
public struct PickerViewUtils<T: Hashable>: View {
    private let titleKey: LocalizedStringKey?
    @Binding private var selection: T
    private let options: [T]

    private let showsSelectedValue: Bool
    private let valueText: (T) -> String
    private let tintColor: Color?
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let usesHaptics: Bool

    private let onUpdate: (() -> Void)?
    
    static func normalizedTitleKey(_ title: String) -> LocalizedStringKey? {
        title.isEmpty ? nil : LocalizedStringKey(title)
    }

    /// Backwards-compatible initializer.
    ///
    /// - Important: `opions` is intentionally misspelled to preserve source compatibility
    ///   with older call sites. Prefer using `init(titleKey:selection:options:...)`.
    public init(
        titleKey: String,
        selection: Binding<T>,
        opions: [T],
        onUpdate: (() -> Void)? = nil
    ) {
        self.titleKey = Self.normalizedTitleKey(titleKey)
        self._selection = selection
        self.options = opions
        self.showsSelectedValue = true
        self.valueText = { String(describing: $0) }
        self.tintColor = nil
        self.backgroundColor = Color.primary.opacity(0.06)
        self.cornerRadius = 12
        self.usesHaptics = true
        self.onUpdate = onUpdate
    }

    /// Creates a modern picker container with consistent typography and contrast.
    ///
    /// This view intentionally does not impose a `pickerStyle`; call sites can apply
    /// `.pickerStyle(.menu)`, `.pickerStyle(.wheel)`, etc.
    ///
    /// - Parameters:
    ///   - titleKey: Optional title displayed above the picker and used as an accessibility label.
    ///   - selection: Current selected value.
    ///   - options: Values shown in the picker.
    ///   - showsSelectedValue: Shows a trailing value readout in the header (helpful for `.menu` pickers).
    ///   - valueText: Converts each option to display text (and drives accessibility value strings).
    ///   - tintColor: Optional accent tint applied to the picker controls.
    ///   - backgroundColor: Container background used to create contrast in light/dark mode.
    ///   - cornerRadius: Container corner radius.
    ///   - usesHaptics: When `true`, emits a selection-changed haptic on updates (UIKit platforms only).
    ///   - onUpdate: Optional callback invoked when the selection changes.
    public init(
        titleKey: LocalizedStringKey? = nil,
        selection: Binding<T>,
        options: [T],
        showsSelectedValue: Bool = true,
        valueText: @escaping (T) -> String = { String(describing: $0) },
        tintColor: Color? = nil,
        backgroundColor: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = 12,
        usesHaptics: Bool = true,
        onUpdate: (() -> Void)? = nil
    ) {
        self.titleKey = titleKey
        self._selection = selection
        self.options = options
        self.showsSelectedValue = showsSelectedValue
        self.valueText = valueText
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.usesHaptics = usesHaptics
        self.onUpdate = onUpdate
    }

    /// Convenience overload that accepts a `String` title.
    public init(
        titleKey: String,
        selection: Binding<T>,
        options: [T],
        showsSelectedValue: Bool = true,
        valueText: @escaping (T) -> String = { String(describing: $0) },
        tintColor: Color? = nil,
        backgroundColor: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = 12,
        usesHaptics: Bool = true,
        onUpdate: (() -> Void)? = nil
    ) {
        self.init(
            titleKey: Self.normalizedTitleKey(titleKey),
            selection: selection,
            options: options,
            showsSelectedValue: showsSelectedValue,
            valueText: valueText,
            tintColor: tintColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            usesHaptics: usesHaptics,
            onUpdate: onUpdate
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            picker
        }
        .padding(12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .tint(tintColor)
        .onChange(of: selection) { _, _ in
            // Keep side effects opt-in and lightweight: caller decides what "update" means.
            onUpdate?()
            if usesHaptics { Haptics.selectionChanged() }
        }
        .accessibilityElement(children: .contain)
        .utilAccessibilityLabel(titleKey)
        .accessibilityValue(valueText(selection))
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

            if showsSelectedValue {
                Text(valueText(selection))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .accessibilityHidden(true)
            }
        }
    }

    private var picker: some View {
        Picker(selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(valueText(option))
                    .tag(option)
            }
        } label: {
            if let titleKey {
                Text(titleKey)
            }
        }
        .labelsHidden()
        .accessibilityValue(valueText(selection))
    }
}

/// A date picker wrapper with a consistent container style and an optional value readout.
///
/// Why this exists:
/// - A raw `DatePicker` is functional, but in many screens it benefits from a consistent
///   “settings card” layout and an explicit formatted value line.
///
/// Accessibility:
/// - Exposes an accessibility label (when provided) and the current formatted value.
public struct DatePickerViewUtils: View {
    private let labelKey: LocalizedStringKey?
    @Binding private var date: Date
    private let alignment: HorizontalAlignment

    private let displayedComponents: DatePickerComponents
    private let showsValue: Bool
    private let valuePrefix: String?
    private let valueText: (Date) -> String

    private let tintColor: Color?
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let usesHaptics: Bool
    private let onUpdate: (() -> Void)?
    
    static func valueLineText(valuePrefix: String?, valueText: String) -> String {
        let prefix = valuePrefix.map { "\($0) " } ?? ""
        return "\(prefix)\(valueText)"
    }

    /// Backwards-compatible initializer.
    public init(
        labelKey: String = "",
        date: Binding<Date>,
        label: String = "",
        alignment: HorizontalAlignment = .leading
    ) {
        self.labelKey = labelKey.isEmpty ? nil : LocalizedStringKey(labelKey)
        self._date = date
        self.alignment = alignment
        self.displayedComponents = [.date]
        self.showsValue = true
        self.valuePrefix = label.isEmpty ? nil : label
        self.valueText = { $0.formatted(date: .long, time: .omitted) }
        self.tintColor = nil
        self.backgroundColor = Color.primary.opacity(0.06)
        self.cornerRadius = 12
        self.usesHaptics = true
        self.onUpdate = nil
    }

    /// Creates a date picker container with consistent typography and contrast.
    ///
    /// - Parameters:
    ///   - labelKey: Optional title shown above the picker and used as an accessibility label.
    ///   - date: The selected date binding.
    ///   - valuePrefix: Optional prefix for the formatted value line (e.g. `"Selected:"`).
    ///   - displayedComponents: Whether the picker shows date, time, or both.
    ///   - showsValue: Whether to show a formatted value line under the picker.
    ///   - valueText: Formats the selected date for display and accessibility value.
    ///   - alignment: Horizontal alignment of the container content.
    ///   - tintColor: Optional accent tint applied to the picker controls.
    ///   - backgroundColor: Container background used to create contrast in light/dark mode.
    ///   - cornerRadius: Container corner radius.
    ///   - usesHaptics: When `true`, emits a selection-changed haptic on updates (UIKit platforms only).
    ///   - onUpdate: Optional callback invoked when the date changes.
    public init(
        labelKey: LocalizedStringKey? = nil,
        date: Binding<Date>,
        valuePrefix: String? = nil,
        displayedComponents: DatePickerComponents = [.date],
        showsValue: Bool = true,
        valueText: @escaping (Date) -> String = { $0.formatted(date: .long, time: .omitted) },
        alignment: HorizontalAlignment = .leading,
        tintColor: Color? = nil,
        backgroundColor: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = 12,
        usesHaptics: Bool = true,
        onUpdate: (() -> Void)? = nil
    ) {
        self.labelKey = labelKey
        self._date = date
        self.valuePrefix = valuePrefix
        self.displayedComponents = displayedComponents
        self.showsValue = showsValue
        self.valueText = valueText
        self.alignment = alignment
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.usesHaptics = usesHaptics
        self.onUpdate = onUpdate
    }

    /// Convenience overload that accepts a `String` label.
    public init(
        labelKey: String,
        date: Binding<Date>,
        valuePrefix: String? = nil,
        displayedComponents: DatePickerComponents = [.date],
        showsValue: Bool = true,
        valueText: @escaping (Date) -> String = { $0.formatted(date: .long, time: .omitted) },
        alignment: HorizontalAlignment = .leading,
        tintColor: Color? = nil,
        backgroundColor: Color = Color.primary.opacity(0.06),
        cornerRadius: CGFloat = 12,
        usesHaptics: Bool = true,
        onUpdate: (() -> Void)? = nil
    ) {
        self.init(
            labelKey: labelKey.isEmpty ? nil : LocalizedStringKey(labelKey),
            date: date,
            valuePrefix: valuePrefix,
            displayedComponents: displayedComponents,
            showsValue: showsValue,
            valueText: valueText,
            alignment: alignment,
            tintColor: tintColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            usesHaptics: usesHaptics,
            onUpdate: onUpdate
        )
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: 10) {
            header
            datePicker
            if showsValue {
                valueLine
            }
        }
        .padding(12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .tint(tintColor)
        .onChange(of: date) { _, _ in
            onUpdate?()
            if usesHaptics { Haptics.selectionChanged() }
        }
        .accessibilityElement(children: .contain)
        .utilAccessibilityLabel(labelKey)
        .accessibilityValue(valueText(date))
    }

    private var header: some View {
        Group {
            if let labelKey {
                Text(labelKey)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
        }
    }

    private var datePicker: some View {
        DatePicker(selection: $date, displayedComponents: displayedComponents) {
            if let labelKey {
                Text(labelKey)
            }
        }
        .labelsHidden()
        .accessibilityValue(valueText(date))
    }

    private var valueLine: some View {
        Text(Self.valueLineText(valuePrefix: valuePrefix, valueText: valueText(date)))
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
    }
}

private enum Haptics {
    static func selectionChanged() {
#if canImport(UIKit)
        // Guarded import keeps this file usable for Mac Catalyst and other contexts without
        // forcing UIKit as a hard dependency for the whole module.
        UISelectionFeedbackGenerator().selectionChanged()
#endif
    }
}

private extension View {
    @ViewBuilder
    func utilAccessibilityLabel(_ titleKey: LocalizedStringKey?) -> some View {
        if let titleKey {
            // Prefer `Text` so localized keys stay localized in VoiceOver.
            self.accessibilityLabel(Text(titleKey))
        } else {
            self
        }
    }
}

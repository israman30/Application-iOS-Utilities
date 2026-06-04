//
//  ButtonView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI
import UIKit

// MARK: - Demo / usage
struct ButtonView: View {
    @State private var isUploading: Bool = false
    @State private var lastEvent: String = "No events yet"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Buttons")
                .font(.title2.weight(.semibold))

            Text(lastEvent)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Last event: \(lastEvent)")

            ButtonViewUtils(label: "Delete item", icon: "trash") {
                lastEvent = "Tapped: Delete item"
            }
            .buttonStyle(.dangerUtil)

            ButtonViewUtils(
                title: "Upload",
                icon: "arrow.up.circle.fill",
                isLoading: isUploading,
                onLongPress: { lastEvent = "Long pressed: Upload" }
            ) {
                lastEvent = "Tapped: Upload"
                isUploading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isUploading = false
                    lastEvent = "Finished: Upload"
                }
            }
            .buttonStyle(.blueUtil)

            Divider().padding(.vertical, 4)

            Button("Primary") { lastEvent = "Tapped: Primary" }
                .utilButtonType(.primary)

            Button("Secondary") { lastEvent = "Tapped: Secondary" }
                .utilButtonType(.secondary)

            Button("Destructive") { lastEvent = "Tapped: Destructive" }
                .utilButtonType(.destructive)
        }
        .padding()
    }
}

#if DEBUG
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
#endif

// MARK: - Public component
/// A reusable SwiftUI button wrapper with sensible UX defaults.
///
/// `ButtonViewUtils` provides:
/// - **Consistent tap target**: a minimum 44pt height.
/// - **Optional SF Symbol**: show an icon next to the title.
/// - **Loading state**: `isLoading` swaps the label with a `ProgressView` and disables taps.
/// - **Optional long-press event**: `onLongPress` can be used for secondary actions.
/// - **Accessibility**: when `title` is provided, it is also used as the accessibility label.
///
/// Most projects will pair it with the included styles:
/// - `.buttonStyle(.blueUtil)` for primary actions
/// - `.buttonStyle(.dangerUtil)` for destructive actions
/// - `.buttonStyle(.grayUtil)` for neutral/secondary actions
///
/// Example:
/// ```swift
/// @State private var isSaving = false
///
/// ButtonViewUtils(
///     title: "Save",
///     icon: "checkmark.circle.fill",
///     isLoading: isSaving,
///     onLongPress: { /* show options */ }
/// ) {
///     isSaving = true
///     // perform work...
/// }
/// .buttonStyle(.blueUtil)
/// ```
public struct ButtonViewUtils: View {
    private let title: String?
    private let icon: String?
    private let action: () -> Void
    private let customLabel: AnyView?
    private let role: ButtonRole?
    private let isLoading: Bool
    private let onLongPress: (() -> Void)?
    private let longPressDuration: Double
    
    static func accessibilityTitle(_ title: String?) -> String? {
        if let title, !title.isEmpty { return title }
        return nil
    }
    
    static func shouldInvokeAction(isLoading: Bool) -> Bool {
        !isLoading
    }
    
    /// Creates a `ButtonViewUtils` with a default label (title + optional SF Symbol).
    ///
    /// - Parameters:
    ///   - title: The button title. When provided, it is also used as the accessibility label.
    ///   - icon: Optional SF Symbol name to show next to the title (e.g. `"trash"`).
    ///   - role: Optional `ButtonRole` (e.g. `.destructive`) for system semantics.
    ///   - isLoading: When `true`, shows a spinner and disables interaction.
    ///   - onLongPress: Optional long-press handler for secondary actions.
    ///   - longPressDuration: Minimum press duration before `onLongPress` fires.
    ///   - action: Invoked on tap when not loading.
    public init(
        title: String? = nil,
        icon: String? = nil,
        role: ButtonRole? = nil,
        isLoading: Bool = false,
        onLongPress: (() -> Void)? = nil,
        longPressDuration: Double = 0.45,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.role = role
        self.isLoading = isLoading
        self.onLongPress = onLongPress
        self.longPressDuration = longPressDuration
        self.action = action
        self.customLabel = nil
    }

    /// Creates a `ButtonViewUtils` with a fully custom label view.
    ///
    /// Use this when you need richer layouts (e.g. a `VStack` with a subtitle).
    /// The label view is responsible for its own typography and layout.
    ///
    /// - Important: If you omit `title`, the button will not set a custom accessibility label.
    public init<Content: View>(
        title: String? = nil,
        icon: String? = nil,
        role: ButtonRole? = nil,
        isLoading: Bool = false,
        onLongPress: (() -> Void)? = nil,
        longPressDuration: Double = 0.45,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.role = role
        self.isLoading = isLoading
        self.onLongPress = onLongPress
        self.longPressDuration = longPressDuration
        self.action = action
        self.customLabel = AnyView(label())
    }
    
    /// Backwards-compatible initializer.
    ///
    /// Prefer `init(title:icon:role:isLoading:onLongPress:longPressDuration:action:)` for new code.
    public init(label: String, icon: String? = nil, action: @escaping () -> Void) {
        self.init(title: label, icon: icon, action: action)
    }
    
    public var body: some View {
        Button(role: role) {
            guard Self.shouldInvokeAction(isLoading: isLoading) else { return }
            action()
        } label: {
            ZStack {
                labelView.opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .accessibilityLabel("Loading")
                }
            }
        }
        .utilAccessibilityLabel(accessibilityTitle)
        .disabled(isLoading)
        .simultaneousGesture(longPressGesture)
    }
    
    private var accessibilityTitle: String? {
        Self.accessibilityTitle(title)
    }
    
    @ViewBuilder
    private var labelView: some View {
        if let customLabel {
            customLabel
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: 44)
        } else {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                if let title, !title.isEmpty {
                    Text(title)
                }
            }
            .font(.headline.weight(.semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 44)
        }
    }

    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .onEnded { _ in
                guard Self.shouldInvokeAction(isLoading: isLoading) else { return }
                onLongPress?()
            }
    }
}

private extension View {
    @ViewBuilder
    func utilAccessibilityLabel(_ title: String?) -> some View {
        if let title, !title.isEmpty {
            self.accessibilityLabel(title)
        } else {
            self
        }
    }
}

enum ButtonUtilsStyle {
    case `default`
    case danger
    case warning
    case gray
    case green
    case blue
    case clear
}

// MARK: - Shared style implementation
/// Defines the surface treatment used by `UtilButtonUtilsStyle`.
private enum UtilButtonSurface {
    case filled
    case soft
    case outline
    case clear
}

/// Captures a small set of colors used by `UtilButtonUtilsStyle`.
///
/// The palette is intentionally small so button styles remain consistent across the library.
private struct UtilButtonPalette {
    let tint: Color
    let foreground: Color
    let surface: UtilButtonSurface
}

/// Internal implementation used by the public `.dangerUtil/.blueUtil/...` button styles.
///
/// This style focuses on a few UX pillars:
/// - **Legibility**: high-contrast foreground/background pairing for primary variants.
/// - **Press affordance**: subtle scale/opacity animation while pressed.
/// - **Tactile feedback**: optional haptic on press for primary/destructive actions.
private struct UtilButtonUtilsStyle: ButtonStyle {
    let palette: UtilButtonPalette
    let cornerRadius: CGFloat
    let pressHaptic: UIImpactFeedbackGenerator.FeedbackStyle?

    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(effectiveForeground)
            .background { backgroundView(isPressed: configuration.isPressed) }
            .overlay { borderView(isPressed: configuration.isPressed) }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: shadowColor(isPressed: configuration.isPressed), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .opacity(effectiveOpacity(isPressed: configuration.isPressed))
            .animation(.snappy(duration: 0.18), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) {_, isPressed in
                guard isPressed, isEnabled, let pressHaptic else { return }
                UIImpactFeedbackGenerator(style: pressHaptic).impactOccurred()
            }
    }

    private var effectiveForeground: Color {
        isEnabled ? palette.foreground : palette.foreground.opacity(0.6)
    }

    private func effectiveOpacity(isPressed: Bool) -> Double {
        guard isEnabled else { return 0.55 }
        return isPressed ? 0.92 : 1.0
    }

    private func shadowColor(isPressed: Bool) -> Color {
        guard isEnabled else { return .clear }
        if palette.surface == .clear { return .clear }
        return Color.black.opacity(isPressed ? 0.10 : 0.18)
    }

    @ViewBuilder
    private func backgroundView(isPressed: Bool) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        switch palette.surface {
        case .filled:
            shape.fill(palette.tint.gradient)
        case .soft:
            shape.fill(palette.tint.opacity(isEnabled ? (isPressed ? 0.30 : 0.18) : 0.10))
        case .outline:
            shape.fill(Color(uiColor: .secondarySystemBackground).opacity(isPressed ? 0.85 : 1.0))
        case .clear:
            shape.fill(Color.clear)
        }
    }

    @ViewBuilder
    private func borderView(isPressed: Bool) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let lineWidth: CGFloat = (palette.surface == .filled) ? 0 : 1.5

        switch palette.surface {
        case .filled:
            shape.strokeBorder(Color.clear, lineWidth: 0)
        case .soft:
            shape.strokeBorder(palette.tint.opacity(isEnabled ? 0.30 : 0.18), lineWidth: 1)
        case .outline:
            shape.strokeBorder(palette.tint.opacity(isEnabled ? (isPressed ? 0.55 : 0.40) : 0.25), lineWidth: lineWidth)
        case .clear:
            shape.strokeBorder(palette.tint.opacity(isEnabled ? (isPressed ? 0.55 : 0.35) : 0.20), lineWidth: 1)
        }
    }
}

/// Support `Utils` button style section
extension ButtonStyle where Self == DangerButtonUtilsStyle {
    static var dangerUtil: DangerButtonUtilsStyle { .init() }
}

extension ButtonStyle where Self == WarningButtonUtilsStyle {
    static var warningUtil: WarningButtonUtilsStyle { .init() }
}

extension ButtonStyle where Self == GrayButtonUtilsStyle {
    static var grayUtil: GrayButtonUtilsStyle { .init() }
}

extension ButtonStyle where Self == GreenButtonUtilsStyle {
    static var greenUtil: GreenButtonUtilsStyle { .init() }
}

extension ButtonStyle where Self == BlueButtonUtilsStyle {
    static var blueUtil: BlueButtonUtilsStyle { .init() }
}

extension ButtonStyle where Self == ClearButtonUtilsStyle {
    static var clearUtil: ClearButtonUtilsStyle { .init() }
}

// Button style components
/// A high-contrast destructive style (filled red) with press animation and light haptics.
struct DangerButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        UtilButtonUtilsStyle(
            palette: .init(tint: .red, foreground: .white, surface: .filled),
            cornerRadius: 14,
            pressHaptic: .light
        )
        .makeBody(configuration: configuration)
    }
}

/// A high-contrast warning style (filled orange) with press animation and light haptics.
struct WarningButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        UtilButtonUtilsStyle(
            palette: .init(tint: .orange, foreground: .black, surface: .filled),
            cornerRadius: 14,
            pressHaptic: .light
        )
        .makeBody(configuration: configuration)
    }
}

/// A neutral, outline style that adapts well to light/dark mode.
struct GrayButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        UtilButtonUtilsStyle(
            palette: .init(tint: .gray, foreground: .primary, surface: .outline),
            cornerRadius: 14,
            pressHaptic: .light
        )
        .makeBody(configuration: configuration)
    }
}

/// A high-contrast success style (filled green) with press animation and light haptics.
struct GreenButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        UtilButtonUtilsStyle(
            palette: .init(tint: .green, foreground: .white, surface: .filled),
            cornerRadius: 14,
            pressHaptic: .light
        )
        .makeBody(configuration: configuration)
    }
}

/// A high-contrast primary style (filled blue) with press animation and light haptics.
struct BlueButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        UtilButtonUtilsStyle(
            palette: .init(tint: .blue, foreground: .white, surface: .filled),
            cornerRadius: 14,
            pressHaptic: .light
        )
        .makeBody(configuration: configuration)
    }
}

/// A lightweight, clear-background style intended for inline actions.
struct ClearButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        UtilButtonUtilsStyle(
            palette: .init(tint: .blue, foreground: .blue, surface: .clear),
            cornerRadius: 14,
            pressHaptic: nil
        )
        .makeBody(configuration: configuration)
    }
}

// MARK: - Button Style 2
enum ButtonStyleType {
    case primary
    case secondary
    case destructive
}

/// Applies a system button appearance preset.
///
/// This modifier is a lightweight convenience wrapper around SwiftUI's built-in button styles.
/// Prefer it when you want buttons that match the platform conventions (instead of the custom
/// `.dangerUtil/.blueUtil/...` styles above).
public struct SystemButtonModifier: ViewModifier {
    let type: ButtonStyleType
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        Group {
            switch type {
            case .primary:
                content
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
            case .secondary:
                content
                    .buttonStyle(.bordered)
                    .tint(.blue)
            case .destructive:
                content
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
            }
        }
        .controlSize(.large)
        .font(.headline.weight(.semibold))
    }
}

extension View {
    /// Applies a platform-style preset for system buttons.
    ///
    /// Example:
    /// ```swift
    /// Button("Primary") { }
    ///     .utilButtonType(.primary)
    /// ```
    func utilButtonType(_ type: ButtonStyleType) -> some View {
        modifier(SystemButtonModifier(type: type))
    }
}

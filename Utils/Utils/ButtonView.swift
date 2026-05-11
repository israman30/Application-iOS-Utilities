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
public struct ButtonViewUtils: View {
    private let title: String?
    private let icon: String?
    private let action: () -> Void
    private let customLabel: AnyView?
    private let role: ButtonRole?
    private let isLoading: Bool
    private let onLongPress: (() -> Void)?
    private let longPressDuration: Double
    
    /// Creates a util button with an optional default title (shown when no custom label is provided).
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

    /// Creates a util button with a fully custom SwiftUI label (Text/Image/VStack/Label/etc.).
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
    public init(label: String, icon: String? = nil, action: @escaping () -> Void) {
        self.init(title: label, icon: icon, action: action)
    }
    
    public var body: some View {
        Button(role: role) {
            guard !isLoading else { return }
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
        if let title, !title.isEmpty { return title }
        return nil
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
                guard !isLoading else { return }
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
private enum UtilButtonSurface {
    case filled
    case soft
    case outline
    case clear
}

private struct UtilButtonPalette {
    let tint: Color
    let foreground: Color
    let surface: UtilButtonSurface
}

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
    func utilButtonType(_ type: ButtonStyleType) -> some View {
        modifier(SystemButtonModifier(type: type))
    }
}

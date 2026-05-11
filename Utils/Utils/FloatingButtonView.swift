//
//  FloatingButtonView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI
import UIKit

// MARK: - Demo / usage
struct FloatingButtonView: View {
    @State private var isCreating: Bool = false
    @State private var lastEvent: String = "No events yet"
    @State private var alignment: AlignmentFloatingButton = .trailing

    var body: some View {
        NavigationStack {
            ZStack {
                List(0..<50) { item in
                    NavigationLink {
                        Text("Detail for item \(item + 1)")
                    } label: {
                        Text("Item \((item + 1))")
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Floating Button")
                        .font(.title2.weight(.semibold))
                        .padding(.horizontal)
                        .padding(.top, 10)

                    Text(lastEvent)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .accessibilityLabel("Last event: \(lastEvent)")

                    Spacer()
                }

                FloatingButtonUtilsView(
                    title: "Add item",
                    alignment: alignment,
                    tint: .blue,
                    icon: "plus",
                    isLoading: isCreating,
                    onLongPress: { lastEvent = "Long pressed: Add item" }
                ) {
                    lastEvent = "Tapped: Add item"
                    isCreating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isCreating = false
                        lastEvent = "Finished: Add item"
                    }
                }
            }
            .navigationTitle("Floating Button")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(alignment == .trailing ? "Right" : "Left") {
                        alignment = (alignment == .trailing) ? .leading : .trailing
                        lastEvent = "Alignment: \(alignment == .trailing ? "Right" : "Left")"
                    }
                    .utilButtonType(.secondary)
                }
            }
        }
    }
}

#if DEBUG
struct FloatingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonView()
    }
}
#endif

// MARK: - Public types
/// Alignment options for placing the floating button in its container.
public enum AlignmentFloatingButton {
    case leading
    case trailing
}

// MARK: - Public component
/// A reusable floating action button (FAB) component for SwiftUI.
///
/// `FloatingButtonUtilsView` provides a few UX defaults that make floating buttons feel
/// consistent across screens:
/// - **Minimum tap target**: `size` is clamped to at least 44pt.
/// - **Legibility**: the icon/spinner color is chosen to contrast with `tint`.
/// - **Press affordance**: subtle scale/opacity animation while pressed.
/// - **Feedback**: optional haptic when the button is pressed.
/// - **Loading state**: when `isLoading == true`, shows a spinner and disables interaction.
/// - **Long press**: optional secondary action via `onLongPress`.
///
/// Example:
/// ```swift
/// FloatingButtonUtilsView(
///     title: "Create",
///     alignment: .trailing,
///     tint: .blue,
///     icon: "plus",
///     isLoading: isSaving,
///     onLongPress: { showQuickActions = true }
/// ) {
///     isSaving = true
///     // perform work...
/// }
/// ```
public struct FloatingButtonUtilsView: View {
    private let title: String?
    private let icon: String
    private let tint: Color
    private let size: CGFloat
    private let isLoading: Bool
    private let action: () -> Void
    private let alignment: AlignmentFloatingButton
    private let onLongPress: (() -> Void)?
    private let longPressDuration: Double
    private let pressHaptic: UIImpactFeedbackGenerator.FeedbackStyle?
    
    /// Creates a floating button.
    ///
    /// - Parameters:
    ///   - title: Used for accessibility labeling. Keep it short and action-oriented (e.g. "Add item").
    ///   - alignment: Places the button on the leading or trailing edge.
    ///   - tint: The button background color.
    ///   - icon: SF Symbol name displayed in the circle (e.g. `"plus"`).
    ///   - size: The circle size. Values under 44 are clamped to 44 to preserve the minimum tap target.
    ///   - isLoading: When `true`, shows a spinner and disables tap/long-press.
    ///   - pressHaptic: Optional haptic style fired when the press begins.
    ///   - onLongPress: Optional long-press handler (useful for secondary actions).
    ///   - longPressDuration: Minimum press duration before `onLongPress` fires.
    ///   - action: Invoked on tap when not loading.
    public init(
        title: String? = nil,
        alignment: AlignmentFloatingButton = .trailing,
        tint: Color = .blue,
        icon: String = "plus",
        size: CGFloat = 56,
        isLoading: Bool = false,
        pressHaptic: UIImpactFeedbackGenerator.FeedbackStyle? = .light,
        onLongPress: (() -> Void)? = nil,
        longPressDuration: Double = 0.45,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.tint = tint
        self.icon = icon
        self.size = max(44, size)
        self.isLoading = isLoading
        self.action = action
        self.alignment = alignment
        self.onLongPress = onLongPress
        self.longPressDuration = longPressDuration
        self.pressHaptic = pressHaptic
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    if alignment == .trailing {
                        Spacer()
                        floatingButton
                    } else {
                        floatingButton
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var floatingButton: some View {
        Button {
            guard !isLoading else { return }
            action()
        } label: {
            ZStack {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(effectiveForeground)
                        .accessibilityLabel("Loading")
                }
            }
            .frame(width: size, height: size)
            .contentShape(Circle())
        }
        .buttonStyle(
            FloatingButtonUtilsStyle(
                tint: tint,
                foreground: effectiveForeground,
                size: size,
                pressHaptic: pressHaptic
            )
        )
        .utilAccessibilityLabel(title ?? "Floating button")
        .accessibilityValue(isLoading ? "Loading" : "")
        .disabled(isLoading)
        .simultaneousGesture(longPressGesture)
        .padding(16)
    }

    private var effectiveForeground: Color {
        titleContrastForeground(for: tint)
    }

    private func titleContrastForeground(for tint: Color) -> Color {
        // We use a lightweight luminance heuristic (not full WCAG contrast computation)
        // to choose between black/white foreground. This keeps the API simple while
        // improving legibility for common solid tints.
        let uiColor = UIColor(tint)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return .white
        }

        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return luminance > 0.60 ? .black : .white
    }

    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .onEnded { _ in
                guard !isLoading else { return }
                onLongPress?()
            }
    }
}

// MARK: - Internal style
private struct FloatingButtonUtilsStyle: ButtonStyle {
    let tint: Color
    let foreground: Color
    let size: CGFloat
    let pressHaptic: UIImpactFeedbackGenerator.FeedbackStyle?

    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .foregroundStyle(isEnabled ? foreground : foreground.opacity(0.6))
            .background { backgroundView(isPressed: configuration.isPressed) }
            .overlay { borderView(isPressed: configuration.isPressed) }
            .clipShape(Circle())
            .shadow(color: shadowColor(isPressed: configuration.isPressed), radius: 10, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(effectiveOpacity(isPressed: configuration.isPressed))
            .animation(.snappy(duration: 0.18), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                guard isPressed, isEnabled, let pressHaptic else { return }
                UIImpactFeedbackGenerator(style: pressHaptic).impactOccurred()
            }
    }

    private func effectiveOpacity(isPressed: Bool) -> Double {
        guard isEnabled else { return 0.55 }
        return isPressed ? 0.92 : 1.0
    }

    private func shadowColor(isPressed: Bool) -> Color {
        guard isEnabled else { return .clear }
        return Color.black.opacity(isPressed ? 0.12 : 0.20)
    }

    @ViewBuilder
    private func backgroundView(isPressed: Bool) -> some View {
        Circle()
            .fill(tint.gradient)
            .opacity(isEnabled ? (isPressed ? 0.90 : 1.0) : 0.55)
    }

    @ViewBuilder
    private func borderView(isPressed: Bool) -> some View {
        Circle()
            .strokeBorder(Color.white.opacity(isEnabled ? (isPressed ? 0.18 : 0.10) : 0.0), lineWidth: 1)
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

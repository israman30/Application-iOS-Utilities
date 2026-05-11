//
//  TooltipView.swift
//  Utils
//
//  Created by Israel Manzo on 9/13/25.
//

import SwiftUI
import UIKit

struct TooltipView: View {
    @State private var lastEvent: String = "No events yet"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tooltip / Activity Pill")
                    .font(.title2.weight(.semibold))

                Text(lastEvent)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Last event: \(lastEvent)")

                VStack(alignment: .leading, spacing: 14) {
                    ActivityItemUtils("Label")

                    ActivityItemUtils("Label 2", icon: {
                        Image(systemName: "heart.fill")
                    })

                    ActivityItemUtils(
                        "Tap me",
                        type: .bottom,
                        tint: .blue,
                        onTap: { lastEvent = "Tapped: Tap me" },
                        onLongPress: { lastEvent = "Long pressed: Tap me" },
                        pressHaptic: .light
                    , icon: {
                        Image(systemName: "hand.tap.fill")
                    })

                    ActivityItemUtils("12", type: .left, tint: .orange, icon: {
                        Image(systemName: "bubble.fill")
                    })

                    HStack(spacing: 10) {
                        ActivityItemUtils("12", type: .right, tint: .purple, icon: {
                            Image(systemName: "bubble.fill")
                        })

                        Text("Some text here")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .foregroundStyle(.primary)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            .padding()
        }
    }
}

#if DEBUG
struct TooltipView_Previews: PreviewProvider {
    static var previews: some View {
        TooltipView()
            .preferredColorScheme(.light)
        TooltipView()
            .preferredColorScheme(.dark)
    }
}
#endif

/// A small triangular arrow used by `ActivityItemUtils`.
///
/// The arrow is drawn pointing **up**; `ActivityItemUtils` rotates/offsets it based on `TooltipDirection`.
private struct TooltipArrow: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// Positions the tooltip arrow relative to the pill content.
public enum TooltipDirection {
    case top, left, right, bottom
}

/// A compact “activity pill” / tooltip badge with an optional arrow.
///
/// This component is designed for small callouts like unread counts, hints, or inline status.
/// It adapts to light/dark mode using semantic system colors and supports optional interaction.
///
/// ## Usage
/// ```swift
/// ActivityItemUtils("12", type: .left, tint: .orange, icon: {
///     Image(systemName: "bubble.fill")
/// })
/// ```
///
/// ## Interaction
/// - If `onTap` is provided, the pill becomes a `Button` (with press animation + optional haptic).
/// - `onLongPress` can be used for secondary actions; if both are provided, an accessibility
///   action named “More options” is exposed to VoiceOver.
///
/// ## Accessibility
/// - The icon is hidden from VoiceOver and the pill is exposed as a single element.
/// - Provide `accessibilityLabel`/`accessibilityHint` when the visible title is not descriptive.
public struct ActivityItemUtils<Icon: View>: View {
    private let title: String
    private let type: TooltipDirection
    private let tint: Color?
    private let icon: Icon
    private let onTap: (() -> Void)?
    private let onLongPress: (() -> Void)?
    private let longPressDuration: Double
    private let pressHaptic: UIImpactFeedbackGenerator.FeedbackStyle?
    private let accessibilityLabelOverride: String?
    private let accessibilityHintOverride: String?
    
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency: Bool
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    /// Creates an activity pill / tooltip badge.
    ///
    /// - Parameters:
    ///   - title: Visible text content of the pill.
    ///   - type: Where the arrow appears relative to the pill.
    ///   - tint: Optional accent color used for icon and the pill’s soft surface.
    ///   - onTap: Optional primary action. When set, the view is rendered as a `Button`.
    ///   - onLongPress: Optional long-press action for secondary behavior.
    ///   - longPressDuration: Minimum press duration before `onLongPress` fires.
    ///   - pressHaptic: Optional haptic fired when pressing down (only when `onTap` is set).
    ///   - accessibilityLabel: Overrides the VoiceOver label (defaults to `title`).
    ///   - accessibilityHint: Optional VoiceOver hint string.
    ///   - icon: Optional leading icon (usually an SF Symbol).
    public init(
        _ title: String,
        type: TooltipDirection = .bottom,
        tint: Color? = nil,
        onTap: (() -> Void)? = nil,
        onLongPress: (() -> Void)? = nil,
        longPressDuration: Double = 0.45,
        pressHaptic: UIImpactFeedbackGenerator.FeedbackStyle? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        @ViewBuilder icon: () -> Icon = EmptyView.init
    ) {
        self.title = title
        self.type = type
        self.tint = tint
        self.icon = icon()
        self.onTap = onTap
        self.onLongPress = onLongPress
        self.longPressDuration = longPressDuration
        self.pressHaptic = pressHaptic
        self.accessibilityLabelOverride = accessibilityLabel
        self.accessibilityHintOverride = accessibilityHint
    }
    
    public var body: some View {
        Group {
            if let primaryAction {
                Button {
                    primaryAction()
                } label: {
                    pill
                }
                .buttonStyle(ActivityItemUtilsButtonStyle(pressHaptic: pressHaptic))
                .simultaneousGesture(longPressGesture)
            } else {
                pill
                    .simultaneousGesture(longPressGesture)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabelOverride ?? title)
        .modifierIf(accessibilityHintText != nil) { view in view.accessibilityHint(accessibilityHintText!) }
        .modifierIf(primaryAction != nil) { view in view.accessibilityAction { primaryAction?() } }
        .modifierIf(onLongPress != nil && onTap != nil) { view in
            view.accessibilityAction(named: "More options") { onLongPress?() }
        }
        .opacity(isEnabled ? 1.0 : 0.55)
    }
    
    private var primaryAction: (() -> Void)? {
        onTap ?? onLongPress
    }
    
    private var accessibilityHintText: String? {
        accessibilityHintOverride
    }
    
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .onEnded { _ in onLongPress?() }
    }
    
    private var pill: some View {
        ZStack(alignment: alignment) {
            label
                .background { backgroundShape }
                .overlay { borderShape }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            
            arrow
        }
        .contentShape(Rectangle())
    }
    
    private var label: some View {
        HStack(spacing: 6) {
            if Icon.self != EmptyView.self {
                icon
                    .foregroundStyle(effectiveIconColor)
                    .accessibilityHidden(true)
            }
            
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(effectiveTextColor)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
    
    private var alignment: Alignment {
        switch type {
        case .top:
            return .top
        case .left:
            return .leading
        case .right:
            return .trailing
        case .bottom:
            return .bottom
        }
    }
    
    private var arrow: some View {
        TooltipArrow()
            .fill(backgroundFillColor)
            .overlay {
                TooltipArrow()
                    .stroke(borderStrokeColor, lineWidth: borderWidth)
            }
            .frame(width: 16, height: 8)
            .rotationEffect(arrowRotation)
            .offset(arrowOffset)
            .accessibilityHidden(true)
    }
    
    private var arrowRotation: Angle {
        switch type {
        case .top:
            return .degrees(0)
        case .left:
            return .degrees(-90)
        case .right:
            return .degrees(90)
        case .bottom:
            return .degrees(180)
        }
    }

    private var arrowOffset: CGSize {
        switch type {
        case .top:
            return .init(width: 0, height: -8)
        case .left:
            return .init(width: -10, height: 0)
        case .right:
            return .init(width: 10, height: 0)
        case .bottom:
            return .init(width: 0, height: 8)
        }
    }
    
    private var backgroundFillColor: Color {
        if let tint {
            let baseOpacity: Double = (colorScheme == .dark) ? 0.28 : 0.18
            let contrastBoost: Double = increasedContrast ? 0.10 : 0.0
            return tint.opacity(min(0.50, baseOpacity + contrastBoost))
        }
        
        if reduceTransparency {
            return Color(uiColor: .secondarySystemBackground)
        }
        
        return Color(uiColor: .secondarySystemBackground)
    }
    
    private var borderWidth: CGFloat {
        increasedContrast ? 2.0 : 1.0
    }
    
    private var borderStrokeColor: Color {
        if let tint { return tint.opacity(increasedContrast ? 0.55 : 0.35) }
        return Color(uiColor: .separator).opacity(increasedContrast ? 0.75 : 0.35)
    }
    
    private var effectiveTextColor: Color {
        if let tint, increasedContrast { return tint }
        return .primary
    }
    
    private var effectiveIconColor: Color {
        if let tint { return tint }
        return .secondary
    }
    
    private var shadowColor: Color {
        guard isEnabled else { return .clear }
        return Color.black.opacity(colorScheme == .dark ? 0.30 : 0.12)
    }
    
    private var backgroundShape: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(backgroundFillColor)
    }
    
    private var borderShape: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .strokeBorder(borderStrokeColor, lineWidth: borderWidth)
    }
    
    private var increasedContrast: Bool {
        UIAccessibility.isDarkerSystemColorsEnabled
    }
}

/// Press treatment for tappable `ActivityItemUtils` pills.
///
/// Intentionally lightweight (scale/opacity + optional haptic) so the component can be used inline
/// without feeling “button heavy”.
private struct ActivityItemUtilsButtonStyle: ButtonStyle {
    let pressHaptic: UIImpactFeedbackGenerator.FeedbackStyle?
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
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
}


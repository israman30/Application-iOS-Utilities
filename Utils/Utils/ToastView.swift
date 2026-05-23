//
//  ToastView.swift
//  Utils
//
//  Created by Israel Manzo on 1/28/24.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// A lightweight toast for transient status messages.
///
/// ## Setup
/// Prefer presenting toasts via the included overlay helper:
/// ```swift
/// content
///   .toast(text: "Saved", isVisible: $showToast, style: .success)
/// ```
/// This keeps your screen layout simple and ensures the toast overlays at the chosen edge.
///
/// You can also instantiate `ToastView` directly when you want full control over placement.
///
/// ## Implementation
/// - **Surface + transparency**: uses semantic system surfaces and a small amount of translucency by
///   default. If the user enables **Reduce Transparency**, the toast becomes fully opaque.
/// - **Tinting**: `ToastStyle` can apply a colored overlay without sacrificing legibility.
/// - **Interaction**: supports tap-to-dismiss, swipe-to-dismiss, an optional action, and an optional close button.
/// - **Accessibility**: Dynamic Type-friendly typography, and optional VoiceOver announcement when shown.
///
/// ## Usage
/// ```swift
/// @State private var showToast = false
///
/// Button("Save") { showToast = true }
///   .toast(
///     text: "Operation completed successfully.",
///     isVisible: $showToast,
///     title: "Saved",
///     style: .success,
///     actionTitle: "Undo",
///     action: { /* undo */ }
///   )
/// ```
public struct ToastView: View {
    // MARK: - Public API
    private let text: String
    @Binding private var isVisible: Bool
    private let delayedAnimation: CGFloat
    private let animationDuration: CGFloat
    
    private let title: String?
    private let systemImage: String?
    private let style: ToastStyle
    private let position: ToastPosition
    private let dismissOnTap: Bool
    private let dismissOnSwipe: Bool
    private let showsCloseButton: Bool
    private let actionTitle: String?
    private let action: (() -> Void)?
    private let haptic: ToastHaptic
    private let announcesForVoiceOver: Bool
    private let onDismiss: (() -> Void)?
    
    // MARK: - Environment
    @Environment(\.accessibilityReduceMotion) private var reduceMotion: Bool
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency: Bool
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled: Bool
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast: ColorSchemeContrast
    
    // MARK: - Local state
    @State private var dragOffset: CGFloat = 0
    @State private var didAppear: Bool = false
    
    /// Creates a toast.
    ///
    /// - Parameters:
    ///   - text: Primary toast message.
    ///   - isVisible: Controls whether the toast is visible.
    ///   - delayedAnimation: Auto-dismiss delay **in seconds**. Set to `0` to disable auto-dismiss.
    ///   - animationDuration: Show/hide animation duration **in seconds**.
    ///   - title: Optional title shown above `text`.
    ///   - systemImage: Optional SF Symbol shown leading the text. If `nil`, the style may provide a default icon.
    ///   - style: Visual style variant (tint + optional default icon).
    ///   - position: Placement edge (`.top` or `.bottom`).
    ///   - dismissOnTap: If `true`, tapping the toast dismisses it.
    ///   - dismissOnSwipe: If `true`, swiping the toast toward its edge dismisses it.
    ///   - showsCloseButton: If `true`, shows a close button (useful when `dismissOnTap` is `false`).
    ///   - actionTitle: Optional action button title (e.g. `"Undo"`).
    ///   - action: Optional action invoked by the action button.
    ///   - haptic: Optional haptic fired when the toast appears.
    ///   - announcesForVoiceOver: If `true`, posts a VoiceOver announcement when the toast appears.
    ///   - onDismiss: Optional callback invoked when the toast is dismissed.
    public init(
        text: String,
        isVisible: Binding<Bool>,
        delayedAnimation: CGFloat = 2,
        animationDuration: CGFloat = 0.3,
        title: String? = nil,
        systemImage: String? = nil,
        style: ToastStyle = .neutral,
        position: ToastPosition = .top,
        dismissOnTap: Bool = true,
        dismissOnSwipe: Bool = true,
        showsCloseButton: Bool = false,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        haptic: ToastHaptic = .none,
        announcesForVoiceOver: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) {
        self.text = text
        self._isVisible = isVisible
        self.delayedAnimation = delayedAnimation
        self.animationDuration = animationDuration
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.position = position
        self.dismissOnTap = dismissOnTap
        self.dismissOnSwipe = dismissOnSwipe
        self.showsCloseButton = showsCloseButton
        self.actionTitle = actionTitle
        self.action = action
        self.haptic = haptic
        self.announcesForVoiceOver = announcesForVoiceOver
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if position == .bottom {
                Spacer(minLength: 0)
            }
            if isVisible {
                toastSurface
            }
            if position == .top {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: position.alignment)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .allowsHitTesting(isVisible)
        .onChange(of: isVisible) { _, newValue in
            if newValue {
                // Reset per-presentation state so haptics/announcements run each time.
                didAppear = false
                dragOffset = 0
            }
        }
    }
    
    // MARK: - Toast surface
    private var toastSurface: some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(backgroundSurface)
            .overlay { borderSurface }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            // Slightly stronger, layered shadow so the toast reads as “floating”
            // across both light and dark mode.
            .shadow(color: shadowColor, radius: 14, x: 0, y: 10)
            .shadow(color: shadowColor.opacity(0.55), radius: 2, x: 0, y: 1)
            .offset(y: position.offset(for: dragOffset))
            .opacity(dragOpacity)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onAppear { onToastAppear() }
            .onChange(of: isVisible) { _, newValue in
                if !newValue { onDismiss?() }
            }
            .modifierIf(dismissOnSwipe) { view in
                view.gesture(swipeToDismissGesture)
            }
            .modifierIf(dismissOnTap) { view in
                view.onTapGesture { dismiss(animated: true) }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabelText)
            .modifierIf(accessibilityHintText != nil) { view in
                view.accessibilityHint(accessibilityHintText!)
            }
            .accessibilityAddTraits(.isStaticText)
            .modifierIf(actionTitle != nil && action != nil) { view in
                view.accessibilityAction(named: actionTitle!) { action?() }
            }
            .accessibilityAction(named: "Dismiss") { dismiss(animated: true) }
            .transition(transition)
    }
    
    private var content: some View {
        ViewThatFits(in: .horizontal) {
            horizontalLayout
            verticalLayout
        }
    }
    
    private var horizontalLayout: some View {
        HStack(alignment: .top, spacing: 12) {
            leadingIcon
            
            textStack
                .frame(maxWidth: .infinity, alignment: .leading)
            
            trailingControls
        }
    }
    
    private var verticalLayout: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                leadingIcon
                textStack
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(spacing: 10) {
                Spacer(minLength: 0)
                trailingControls
            }
        }
    }
    
    @ViewBuilder
    private var leadingIcon: some View {
        if let iconName {
            Image(systemName: iconName)
                .symbolRenderingMode(.hierarchical)
                .font(.title3.weight(.semibold))
                .foregroundStyle(iconColor)
                .accessibilityHidden(true)
                .padding(.top, 1)
        }
    }
    
    private var textStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title, !title.isEmpty {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
    
    @ViewBuilder
    private var trailingControls: some View {
        HStack(spacing: 10) {
            if let actionTitle, let action {
                Button(actionTitle) { action() }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .font(.subheadline.weight(.semibold))
            }
            
            if showsCloseButton {
                Button {
                    dismiss(animated: true)
                } label: {
                    Image(systemName: "xmark")
                        .font(.subheadline.weight(.semibold))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss")
            }
        }
    }
    
    // MARK: - Styling
    private var backgroundSurface: some View {
        let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)
        
        return shape
            // Always start from an opaque system surface for legibility.
            .fill(baseBackgroundFill)
            // Then layer the tint on top (still opaque overall, just color-shifted).
            .overlay {
                if let tintOverlayFill {
                    shape.fill(tintOverlayFill)
                }
            }
    }
    
    private var borderSurface: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .strokeBorder(borderColor, lineWidth: borderWidth)
    }
    
    private var baseBackgroundFill: Color {
#if canImport(UIKit)
        // Keep a *small* amount of translucency so the toast feels lightweight,
        // but respect the user's Reduce Transparency setting.
        if reduceTransparency {
            return Color(uiColor: .secondarySystemBackground)
        }
        // More translucency (still readable with shadow + border).
        let baseAlpha: Double = (colorScheme == .dark) ? 0.85 : 0.90
        return Color(uiColor: .secondarySystemBackground).opacity(baseAlpha)
#else
        return Color.primary.opacity(0.08)
#endif
    }
    
    private var tintOverlayFill: Color? {
#if canImport(UIKit)
        guard !reduceTransparency else { return nil }
        guard let tint = style.tint else { return nil }
        
        // More opaque than before to avoid the toast looking “washed out”.
        let baseOpacity: Double = (colorScheme == .dark) ? 0.45 : 0.30
        let contrastBoost: Double = (colorSchemeContrast == .increased) ? 0.10 : 0.0
        return tint.opacity(min(0.68, baseOpacity + contrastBoost))
#else
        return nil
#endif
    }
    
    private var borderWidth: CGFloat {
        colorSchemeContrast == .increased ? 2.0 : 1.0
    }
    
    private var borderColor: Color {
        if let tint = style.tint {
            return tint.opacity(colorSchemeContrast == .increased ? 0.55 : 0.30)
        }
#if canImport(UIKit)
        return Color(uiColor: .separator).opacity(colorSchemeContrast == .increased ? 0.75 : 0.35)
#else
        return Color.primary.opacity(colorSchemeContrast == .increased ? 0.28 : 0.16)
#endif
    }
    
    private var shadowColor: Color {
        Color.black.opacity(colorScheme == .dark ? 0.42 : 0.16)
    }
    
    private var iconColor: Color {
        style.tint ?? .secondary
    }
    
    private var iconName: String? {
        if let systemImage, !systemImage.isEmpty { return systemImage }
        return style.defaultSystemImage
    }
    
    private var transition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .move(edge: position.edge)
            .combined(with: .opacity)
            .animation(.snappy(duration: animationDuration))
    }
    
    // MARK: - Interaction
    private var swipeToDismissGesture: some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .onChanged { value in
                guard dismissOnSwipe else { return }
                let delta = position == .top ? min(0, value.translation.height) : max(0, value.translation.height)
                dragOffset = delta
            }
            .onEnded { value in
                let threshold: CGFloat = 34
                let delta = position == .top ? value.translation.height : -value.translation.height
                if delta < -threshold {
                    dismiss(animated: true)
                } else {
                    withAnimation(reduceMotion ? nil : .snappy(duration: 0.18)) {
                        dragOffset = 0
                    }
                }
            }
    }
    
    private var dragOpacity: Double {
        let normalized = min(1.0, Double(abs(dragOffset) / 90))
        return 1.0 - (0.18 * normalized)
    }
    
    private func dismiss(animated: Bool) {
        let animation = (animated && !reduceMotion) ? Animation.snappy(duration: animationDuration) : nil
        withAnimation(animation) {
            isVisible = false
            dragOffset = 0
        }
    }
    
    private func onToastAppear() {
        guard !didAppear else { return }
        didAppear = true
        
        fireHapticIfNeeded()
        announceIfNeeded()
        scheduleAutoDismissIfNeeded()
    }
    
    private func scheduleAutoDismissIfNeeded() {
        guard delayedAnimation > 0 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayedAnimation) {
            guard isVisible else { return }
            dismiss(animated: true)
        }
    }
    
    private func fireHapticIfNeeded() {
#if canImport(UIKit)
        switch haptic {
        case .none:
            return
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .impact(let style):
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        }
#endif
    }
    
    private func announceIfNeeded() {
#if canImport(UIKit)
        guard announcesForVoiceOver, voiceOverEnabled else { return }
        let message = accessibilityLabelText
        UIAccessibility.post(notification: .announcement, argument: message)
#endif
    }
    
    // MARK: - Accessibility strings
    private var accessibilityLabelText: String {
        if let title, !title.isEmpty {
            return "\(title). \(text)"
        }
        return text
    }
    
    private var accessibilityHintText: String? {
        if dismissOnSwipe && dismissOnTap {
            return "Swipe or tap to dismiss."
        }
        if dismissOnSwipe {
            return "Swipe to dismiss."
        }
        if dismissOnTap {
            return "Tap to dismiss."
        }
        return nil
    }
}

// MARK: - Supporting types
/// Defines the toast's semantic appearance (tint + optional default icon).
///
/// Use `.neutral` for a system-surface toast with no tint, or `.success/.warning/.error` to convey
/// status with a tinted surface and an appropriate default SF Symbol.
public enum ToastStyle: Equatable {
    case neutral
    case info
    case success
    case warning
    case error
    
    /// Provide a custom tint and optional default icon.
    ///
    /// If you pass `systemImage` to `ToastView`, that always takes precedence.
    case custom(tint: Color?, defaultSystemImage: String? = nil)
    
    fileprivate var tint: Color? {
        switch self {
        case .neutral: return nil
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        case .custom(let tint, _): return tint
        }
    }
    
    fileprivate var defaultSystemImage: String? {
        switch self {
        case .neutral: return nil
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        case .custom(_, let icon): return icon
        }
    }
}

/// Vertical placement for the toast overlay.
public enum ToastPosition: Equatable {
    case top
    case bottom
    
    fileprivate var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
    
    fileprivate var edge: Edge {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
    
    fileprivate func offset(for dragOffset: CGFloat) -> CGFloat {
        // Toast is anchored at an edge; offset should follow the drag direction.
        return dragOffset
    }
}

/// Optional haptic feedback fired when the toast appears.
public enum ToastHaptic: Equatable {
    case none
    case success
    case warning
    case error
    case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
}

// MARK: - Usage
/// A small, interactive view that demonstrates how to use `ToastView`.
///
/// This is intended for previews / manual QA:
/// - Verify legibility in light/dark mode and increased contrast.
/// - Test Dynamic Type wrapping and tap/swipe dismiss behavior.
/// - Validate VoiceOver announcements (when enabled) and action affordances.
struct ToastViewSampleView: View {
    @State private var showToast: Bool = false
    @State private var lastEvent: String = "No events yet"
    
    @State private var title: String = "Saved"
    @State private var message: String = "Operation completed successfully."
    @State private var delayedDismiss: Double = 2.5
    
    @State private var styleOption: ToastDemoStyleOption = .success
    @State private var position: ToastPosition = .top
    
    @State private var dismissOnTap: Bool = true
    @State private var dismissOnSwipe: Bool = true
    @State private var showsCloseButton: Bool = true
    
    @State private var includeAction: Bool = true
    @State private var announcesForVoiceOver: Bool = true
    @State private var hapticOption: ToastDemoHapticOption = .success
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("ToastView")
                    .font(.title2.weight(.semibold))
                
                Text(lastEvent)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Last event: \(lastEvent)")
                
                controls
                
                Divider()
                
                Button {
                    lastEvent = "Shown toast"
                    showToast = true
                } label: {
                    Label("Show toast", systemImage: "bell.badge.fill")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    lastEvent = showToast ? "Dismissed toast" : "Shown toast"
                    showToast.toggle()
                } label: {
                    Text(showToast ? "Dismiss" : "Toggle toast")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                
                Spacer(minLength: 0)
            }
            .padding()
        }
        .toast(
            text: message,
            isVisible: $showToast,
            delayedAnimation: CGFloat(delayedDismiss),
            title: title.isEmpty ? nil : title,
            systemImage: nil,
            style: styleOption.style,
            position: position,
            dismissOnTap: dismissOnTap,
            dismissOnSwipe: dismissOnSwipe,
            showsCloseButton: showsCloseButton,
            actionTitle: includeAction ? "Undo" : nil,
            action: includeAction ? {
                lastEvent = "Tapped: Undo"
                showToast = false
            } : nil,
            haptic: hapticOption.haptic,
            announcesForVoiceOver: announcesForVoiceOver,
            onDismiss: {
                lastEvent = "Toast dismissed"
            }
        )
    }
    
    private var controls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                TextField("Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Message", text: $message)
                    .textFieldStyle(.roundedBorder)
            }
            .font(.body)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Auto-dismiss (seconds)")
                    .font(.subheadline.weight(.semibold))
                Slider(value: $delayedDismiss, in: 0...8, step: 0.5) {
                    Text("Auto-dismiss")
                }
                Text(delayedDismiss == 0 ? "Off" : "\(delayedDismiss, specifier: "%.1f")s")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            
            Picker("Style", selection: $styleOption) {
                ForEach(ToastDemoStyleOption.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.menu)
            
            Picker("Position", selection: $position) {
                Text("Top").tag(ToastPosition.top)
                Text("Bottom").tag(ToastPosition.bottom)
            }
            .pickerStyle(.segmented)
            
            Toggle("Dismiss on tap", isOn: $dismissOnTap)
            Toggle("Dismiss on swipe", isOn: $dismissOnSwipe)
            Toggle("Show close button", isOn: $showsCloseButton)
            Toggle("Show action button", isOn: $includeAction)
            Toggle("Announce in VoiceOver", isOn: $announcesForVoiceOver)
            
            Picker("Haptic", selection: $hapticOption) {
                ForEach(ToastDemoHapticOption.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

private enum ToastDemoStyleOption: String, CaseIterable, Identifiable {
    case neutral
    case info
    case success
    case warning
    case error
    
    var id: String { rawValue }
    
    var title: String {
        rawValue.capitalized
    }
    
    var style: ToastStyle {
        switch self {
        case .neutral: return .neutral
        case .info: return .info
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        }
    }
}

private enum ToastDemoHapticOption: String, CaseIterable, Identifiable {
    case none
    case success
    case warning
    case error
    case lightImpact
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .lightImpact: return "Light impact"
        default: return rawValue.capitalized
        }
    }
    
    var haptic: ToastHaptic {
        switch self {
        case .none: return .none
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        case .lightImpact: return .impact(style: .light)
        }
    }
}

public extension View {
    /// Presents a `ToastView` over the receiver.
    ///
    /// ## Setup
    /// Apply this modifier near the root of your screen (e.g. on your `NavigationStack` or main
    /// container) so the toast can overlay the full available area and anchor to `.top` / `.bottom`.
    ///
    /// ## Usage
    /// ```swift
    /// @State private var showToast = false
    ///
    /// VStack {
    ///   Button("Save") { showToast = true }
    /// }
    /// .toast(text: "Saved", isVisible: $showToast, style: .success)
    /// ```
    func toast(
        text: String,
        isVisible: Binding<Bool>,
        delayedAnimation: CGFloat = 2,
        animationDuration: CGFloat = 0.3,
        title: String? = nil,
        systemImage: String? = nil,
        style: ToastStyle = .neutral,
        position: ToastPosition = .top,
        dismissOnTap: Bool = true,
        dismissOnSwipe: Bool = true,
        showsCloseButton: Bool = false,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        haptic: ToastHaptic = .none,
        announcesForVoiceOver: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        overlay {
            ToastView(
                text: text,
                isVisible: isVisible,
                delayedAnimation: delayedAnimation,
                animationDuration: animationDuration,
                title: title,
                systemImage: systemImage,
                style: style,
                position: position,
                dismissOnTap: dismissOnTap,
                dismissOnSwipe: dismissOnSwipe,
                showsCloseButton: showsCloseButton,
                actionTitle: actionTitle,
                action: action,
                haptic: haptic,
                announcesForVoiceOver: announcesForVoiceOver,
                onDismiss: onDismiss
            )
        }
    }
}

#if DEBUG
struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToastViewSampleView()
                .previewDisplayName("Sample view")
            
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                ToastView(
                    text: "Operation completed successfully.",
                    isVisible: .constant(true),
                    title: "Saved",
                    style: .success,
                    position: .top,
                    showsCloseButton: true,
                    actionTitle: "Undo",
                    action: {},
                    haptic: .success
                )
            }
            .previewDisplayName("Success (Top)")
            
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                ToastView(
                    text: "You appear to be offline. Some actions may not work.",
                    isVisible: .constant(true),
                    title: "No connection",
                    style: .error,
                    position: .bottom,
                    showsCloseButton: true
                )
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Error (Bottom / Dark)")
            
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                ToastView(
                    text: "This is a long message that should wrap correctly and remain readable at larger Dynamic Type sizes.",
                    isVisible: .constant(true),
                    style: .info,
                    position: .top,
                    dismissOnTap: false,
                    showsCloseButton: true
                )
            }
            .dynamicTypeSize(.accessibility4)
            .previewDisplayName("Dynamic Type (AX)")
        }
    }
}
#endif

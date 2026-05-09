//
//  ButtonView.swift
//  Utils
//
//  Created by Israel Manzo on 4/9/25.
//

import SwiftUI

struct ButtonView: View {
    @State var isTapped: Bool = true
    
    var body: some View {
        VStack {
            ButtonViewUtils(label: "Tap here", icon: "xmark.circle") {
                // action
            }
            .padding()
            .buttonStyle(.dangerUtil)
            
            ButtonViewUtils(action: {
                // action
            }) {
                VStack(spacing: 6) {
                    Label("Upload", systemImage: "arrow.up.circle.fill")
                    Text("Tap to start")
                        .font(.footnote)
                        .opacity(0.8)
                }
            }
            .padding()
            .buttonStyle(.blueUtil)
            
            Button("Success") {
                // action
            }
            .utilButtonType(.primary)
            
            Button("Secondary") {
                // action
            }
            .utilButtonType(.secondary)
            
            Button("Destructive") {
                // action
            }
            .utilButtonType(.destructive)
        }
    }
}

#if DEBUG
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
#endif

public struct ButtonViewUtils: View {
    private let title: String?
    private let icon: String?
    private let action: () -> Void
    private let customLabel: AnyView?
    
    /// Creates a util button with an optional default title (shown when no custom label is provided).
    public init(title: String? = nil, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
        self.customLabel = nil
    }

    /// Creates a util button with a fully custom SwiftUI label (Text/Image/VStack/Label/etc.).
    public init<Content: View>(
        title: String? = nil,
        icon: String? = nil,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.action = action
        self.customLabel = AnyView(label())
    }
    
    /// Backwards-compatible initializer.
    public init(label: String, icon: String? = nil, action: @escaping () -> Void) {
        self.init(title: label, icon: icon, action: action)
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            labelView
        }
        .utilAccessibilityLabel(accessibilityTitle)
    }
    
    private var accessibilityTitle: String? {
        if let title, !title.isEmpty { return title }
        return nil
    }
    
    @ViewBuilder
    private var labelView: some View {
        if let customLabel {
            customLabel
                .font(.title2)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
        } else {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                if let title, !title.isEmpty {
                    Text(title)
                }
            }
            .font(.title2)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
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
        configuration.label
            .font(.title2)
            .padding(.vertical, 12)
            .foregroundColor(Color.red)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.red, lineWidth: 2.0)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.2))
                    }
            }
    }
}

struct WarningButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding(.vertical, 12)
            .foregroundColor(Color.orange)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.yellow, lineWidth: 2.0)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.yellow.opacity(0.2))
                    }
            }
    }
}

struct GrayButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding(.vertical, 12)
            .foregroundColor(Color.gray)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 2.0)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                    }
            }
    }
}

struct GreenButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding(.vertical, 12)
            .foregroundColor(Color.green)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green, lineWidth: 2.0)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.2))
                    }
            }
    }
}

struct BlueButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding(.vertical, 12)
            .foregroundColor(Color.blue)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 2.0)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.2))
                    }
            }
    }
}

struct ClearButtonUtilsStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding(.vertical, 12)
            .foregroundColor(Color.blue)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 2.0)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear.opacity(0.2))
                    }
            }
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
    
    public func body(content: Content) -> some View {
        let backgroundColor: Color
        let foregroundColor: Color
        
        switch type {
        case .primary:
            backgroundColor = .blue
            foregroundColor = .white
        case .secondary:
            backgroundColor = .gray.opacity(0.2)
            foregroundColor = .black
        case .destructive:
            backgroundColor = .red
            foregroundColor = .white
        }
        return content
            .padding()
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .presentationCornerRadius(8)
    }
}

extension View {
    func utilButtonType(_ type: ButtonStyleType) -> some View {
        modifier(SystemButtonModifier(type: type))
    }
}

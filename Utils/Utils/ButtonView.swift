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

#Preview {
    ButtonView()
}

public struct ButtonViewUtils: View {
    let label: String
    let icon: String?
    let action: () -> Void
    
    init(label: String, icon: String? = nil, action: @escaping() -> Void) {
        self.label = label
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(label)
            }
            .font(.title2)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
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

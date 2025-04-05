//
//  TextFieldUtils.swift
//  Utils
//
//  Created by Israel Manzo on 1/7/24.
//

import SwiftUI

struct TextFieldUtils: View {
    @State var text = ""
    var body: some View {
        VStack {
            UtilTextField(
                placeholder: "Enter something",
                inputText: $text,
                headerText: "Some Header",
                iconPlaceholder: "magnifyingglass",
                shadowRadius: 2
            )
        }
    }
}

#Preview {
    TextFieldUtils()
}

public struct UtilTextField: View {
    var placeholder = ""
    @Binding var inputText: String
    var font: Font = .title
    var headerText = ""
    var iconPlaceholder = ""
    var shadowRadius: CGFloat = 2
    var colors: [Color] = [Color.gray.opacity(0.3), Color.white.opacity(0.2)]
    var startPoint: UnitPoint = .topLeading
    var endPoint: UnitPoint = .bottomTrailing
    var cornerRadius: CGFloat = 20
    var shadowColor: Color = .gray
    
    @ViewBuilder
    public var body: some View {
        VStack(alignment: .leading) {
            Text(headerText)
                .font(.title)
                .accessibilityAddTraits(.isHeader)
                .accessibilityHeading(.h2)
            HStack {
                Image(systemName: iconPlaceholder)
                TextField(placeholder, text: $inputText)
            }
            .padding()
            .font(font)
            .textFieldStyle(.plain)
            .customModifier(
                gradient: colors,
                startPoint: startPoint,
                endPoint: endPoint,
                cornerRadius: cornerRadius,
                shadowRadius: shadowRadius,
                shadowColor: shadowColor
            )
            
        }
        .padding()
        
    }
    
}

struct CustomModifier: ViewModifier {
    var colors: [Color]
    var startPoint: UnitPoint = .topLeading
    var endPoint: UnitPoint = .bottomTrailing
    var cornerRadius: CGFloat = 20
    var shadowRadius: CGFloat = 10
    var shadowColor: Color = .gray
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            )
            .cornerRadius(cornerRadius  )
            .shadow(color: .gray, radius: shadowRadius)
    }
}

extension View {
    func customModifier(
        gradient colors: [Color],
        startPoint: UnitPoint = .topLeading,
        endPoint: UnitPoint = .bottomTrailing,
        cornerRadius: CGFloat = 20,
        shadowRadius: CGFloat = 10,
        shadowColor: Color = .gray
    ) -> some View {
        modifier(
            CustomModifier(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint,
                cornerRadius: cornerRadius,
                shadowRadius: shadowRadius,
                shadowColor: shadowColor
            )
        )
    }
}

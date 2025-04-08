//
//  TextFieldUtils.swift
//  Utils
//
//  Created by Israel Manzo on 1/7/24.
//

import SwiftUI

struct TextFieldUtils: View {
    @State var text = ""
    @State var password = ""
    var body: some View {
        VStack {
            UtilTextField("email" ,inputText: $text) {
                Text("Email")
            }
            
            UtilTextField("password", inputText: $password, isSecure: true) {
                Text("Password")
            }
        }
    }
}

#Preview {
    TextFieldUtils()
}

public struct UtilTextField<Header: View>: View {
    var placeholder: String = ""
    @Binding var inputText: String
    var font: Font = .title
    var headerText = ""
    var iconPlaceholder = ""
    var shadowRadius: CGFloat = 2
    var color: Color = Color.gray.opacity(0.1)
    var cornerRadius: CGFloat = 20
    var shadowColor: Color = .gray
    var isSecure: Bool = false
    var header: () -> Header
    
    init(
        _ placeholder: String = "",
        inputText: Binding<String>,
        font: Font = .title,
        iconPlaceholder: String = "",
        headerText: String = "",
        shadowRadius: CGFloat = 2,
        color: Color = Color.gray.opacity(0.1),
        cornerRadius: CGFloat = 20,
        shadowColor: Color = .gray,
        isSecure: Bool = false,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.placeholder = placeholder
        self._inputText = inputText
        self.font = font
        self.iconPlaceholder = iconPlaceholder
        self.headerText = headerText
        self.shadowColor = shadowColor
        self.color = color
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.isSecure = isSecure
        self.header = header
    }
    
    @ViewBuilder
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconPlaceholder)
                if isSecure {
                    VStack(alignment: .leading) {
                        header()
                        VStack {
                            SecureField(placeholder, text: $inputText)
                        }
                        .padding()
                        .customModifier(gradient: color)
                    }
                } else {
                    VStack(alignment: .leading) {
                        header()
                        VStack {
                            TextField(placeholder, text: $inputText)
                        }
                        .padding()
                        .customModifier(gradient: color)
                    }
                }
            }
            .font(font)
            .textFieldStyle(.plain)
        }
        
    }
    
}

struct CustomModifier: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat = 20
    var shadowRadius: CGFloat = 10
    var shadowColor: Color = .gray
    
    func body(content: Content) -> some View {
        content
            .background(
                color
            )
            .cornerRadius(cornerRadius  )
            .shadow(color: .gray, radius: shadowRadius)
    }
}

extension View {
    func customModifier(
        gradient color: Color,
        cornerRadius: CGFloat = 20,
        shadowRadius: CGFloat = 10,
        shadowColor: Color = .gray
    ) -> some View {
        modifier(
            CustomModifier(
                color: color,
                cornerRadius: cornerRadius,
                shadowRadius: shadowRadius,
                shadowColor: shadowColor
            )
        )
    }
}

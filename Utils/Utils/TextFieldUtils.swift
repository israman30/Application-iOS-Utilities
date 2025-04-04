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
            CustomTextField(
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

struct CustomTextField: View {
    
    var placeholder = ""
    @Binding var inputText: String
    var font: Font = .title
    var headerText = ""
    var iconPlaceholder = ""
    var shadowRadius: CGFloat = 2
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(headerText)
                .font(.title)
            HStack {
                Image(systemName: iconPlaceholder)
                TextField(placeholder, text: $inputText)
            }
            .padding()
            .font(font)
            .textFieldStyle(.plain)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color(.systemGray5), Color.white]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: .gray, radius: shadowRadius)
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
            .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint))
            .cornerRadius(cornerRadius  )
            .shadow(color: .gray, radius: shadowRadius)
    }
}

//
//  FormView.swift
//  Utils
//
//  Created by Israel Manzo on 4/7/25.
//

import SwiftUI

struct FormView: View {
    var body: some View {
        FormViewUtil(header: "Header", content: {
            Text("Body text")
        }, footer: "Footer")
    }
}

#Preview {
    FormView()
}

public struct FormViewUtil<Content: View>: View {
    var header: String = ""
    var content: () -> Content
    var footer: String = ""
    
    init(header: String = "",
        @ViewBuilder content: @escaping () -> Content,
        footer: String = ""
    ) {
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    public var body: some View {
        Form {
            Group {
                Section {
                    content()
                } header: {
                    Text(header)
                } footer: {
                    Text(footer)
                }
            }
        }
    }
}


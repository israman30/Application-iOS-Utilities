//
//  FormView.swift
//  Utils
//
//  Created by Israel Manzo on 4/7/25.
//

import SwiftUI

struct FormView: View {
    var body: some View {
        FormViewUtil {
            Text("Body text")
        } header: {
            Text("Header")
        }

    }
}

#Preview {
    FormView()
}

public struct FormViewUtil<Content: View, Header: View>: View {
    
    var content: () -> Content
    var header: () -> Header
    
    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder header: @escaping () -> Header) {
        self.content = content
        self.header = header
    }
    
    public var body: some View {
        Form {
            Group {
                Section {
                    content()
                } header: {
                    Text("Header")
                }
            }
        }
    }
}

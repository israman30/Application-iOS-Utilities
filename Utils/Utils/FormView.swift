//
//  FormView.swift
//  Utils
//
//  Created by Israel Manzo on 4/7/25.
//

import SwiftUI

struct FormView: View {
    var body: some View {
        VStack {
            FormViewUtil {
                Text("Body Form")
            } header: {
                Text("header")
            } footer: {
                Text("Footer")
            }
            
            FormViewUtil {
                Text("Some View")
            } footer: {
                Text("Some footer")
            }
        }
    }
}

#Preview {
    FormView()
}

public struct FormViewUtil<Content: View, Header: View, Footer: View>: View {
    let content: () -> Content
    var header: (() -> Header)? = nil
    var footer: (() -> Footer)? = nil
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        header: (() -> Header)? = nil,
        footer: (() -> Footer)? = nil
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
                    if let header = header {
                        header()
                    }
                } footer: {
                    if let footer = footer {
                        footer()
                    }
                }
            }
        }
    }
}

extension FormViewUtil where Header == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content, footer: @escaping () -> Footer) {
        self.content = content
        self.header = nil
        self.footer = footer
    }
}

extension FormViewUtil where Footer == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content, header: @escaping () -> Header) {
        self.content = content
        self.header = header
        self.footer = nil
    }
}

extension FormViewUtil where Header == EmptyView, Footer == EmptyView {
    init (@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.header = nil
        self.footer = nil
    }
}

//
//  FormView.swift
//  Utils
//
//  Created by Israel Manzo on 4/7/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct FormView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var wantsUpdates: Bool = true
    @State private var showValidation: Bool = false

    private var emailError: String? {
        guard showValidation else { return nil }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Email is required." }
        if !email.contains("@") { return "Please enter a valid email address." }
        return nil
    }

    private var passwordError: String? {
        guard showValidation else { return nil }
        if password.count < 8 { return "Password must be at least 8 characters." }
        return nil
    }

    var body: some View {
        NavigationStack {
            FormViewUtil(
                content: {
                    VStack(alignment: .leading, spacing: 14) {
                        TextFieldViewUtil(
                            "Name",
                            inputText: $name,
                            iconPlaceholder: "person",
                            headerText: "Name",
                            shadowRadius: 0,
                            color: Color(uiColor: .secondarySystemBackground),
                            cornerRadius: 14,
                            shadowColor: .clear,
                            supportingText: "Use your full name for receipts.",
                            submitLabel: .next,
                            textContentType: .name
                        )

                        TextFieldViewUtil(
                            "Email",
                            inputText: $email,
                            iconPlaceholder: "envelope",
                            headerText: "Email",
                            shadowRadius: 0,
                            color: Color(uiColor: .secondarySystemBackground),
                            cornerRadius: 14,
                            shadowColor: .clear,
                            supportingText: "We’ll only use this to contact you.",
                            errorText: emailError,
                            submitLabel: .next,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress
                        )

                        TextFieldViewUtil(
                            "Password",
                            inputText: $password,
                            iconPlaceholder: "lock",
                            headerText: "Password",
                            shadowRadius: 0,
                            color: Color(uiColor: .secondarySystemBackground),
                            cornerRadius: 14,
                            shadowColor: .clear,
                            isSecure: true,
                            supportingText: "Use 8+ characters.",
                            errorText: passwordError,
                            submitLabel: .done,
                            textContentType: .password
                        )

                        ToggleViewUtils(
                            title: "Product updates",
                            subtitle: "Occasional emails about new features.",
                            icon: "sparkles",
                            isOn: $wantsUpdates,
                            tintColor: .blue,
                            backgroundColor: Color(uiColor: .secondarySystemBackground),
                            usesHaptics: true
                        )

                        ButtonViewUtils(title: "Create account", icon: "checkmark.circle.fill") {
                            showValidation = true
                        }
                        .buttonStyle(.blueUtil)
                        .accessibilityHint("Validates the form and creates your account.")
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                },
                headerText: "Create account",
                footerText: "Your information is stored securely. You can update preferences at any time."
            )
            .navigationTitle("Form")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Validate") { showValidation = true }
            }
        }
    }
}

#if DEBUG
struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
#endif

public struct FormViewUtil<Content: View, Header: View, Footer: View>: View {
    let content: () -> Content
    var header: (() -> Header)? = nil
    var footer: (() -> Footer)? = nil

    private let backgroundColor: Color
    private let sectionBackgroundColor: Color
    private let rowSeparatorVisibility: Visibility
    private let accessibilityIdentifier: String?

    @Environment(\.colorSchemeContrast) private var colorSchemeContrast: ColorSchemeContrast
    
    public init(
        @ViewBuilder content: @escaping () -> Content,
        header: (() -> Header)? = nil,
        footer: (() -> Footer)? = nil,
        backgroundColor: Color = Color(uiColor: .systemGroupedBackground),
        sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground),
        rowSeparatorVisibility: Visibility = .automatic,
        accessibilityIdentifier: String? = nil
    ) {
        self.content = content
        self.header = header
        self.footer = footer
        self.backgroundColor = backgroundColor
        self.sectionBackgroundColor = sectionBackgroundColor
        self.rowSeparatorVisibility = rowSeparatorVisibility
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    public var body: some View {
        if #available(iOS 16.0, *) {
            baseForm
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
        } else {
            baseForm
        }
    }

    private var baseForm: some View {
        Form {
            Section {
                content()
            } header: {
                if let header = header {
                    header()
                        .textCase(nil)
                        .accessibilityAddTraits(.isHeader)
                }
            } footer: {
                if let footer = footer {
                    footer()
                        .textCase(nil)
                }
            }
            .listRowBackground(sectionBackgroundColor)
            .listRowSeparator(rowSeparatorVisibility)
        }
        .listStyle(.insetGrouped)
        .modifierIf(colorSchemeContrast == .increased) { view in
            view.listRowSeparatorTint(Color.primary.opacity(0.35))
        }
        .modifierIf(colorSchemeContrast != .increased) { view in
            view.listRowSeparatorTint(Color.primary.opacity(0.18))
        }
        .background(backgroundColor.ignoresSafeArea())
        .modifierIf(accessibilityIdentifier != nil) { view in
            view.accessibilityIdentifier(accessibilityIdentifier!)
        }
    }
}

extension FormViewUtil where Header == EmptyView {
    public init(
        @ViewBuilder content: @escaping () -> Content,
        footer: @escaping () -> Footer,
        backgroundColor: Color = Color(uiColor: .systemGroupedBackground),
        sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground),
        rowSeparatorVisibility: Visibility = .automatic,
        accessibilityIdentifier: String? = nil
    ) {
        self.init(
            content: content,
            header: nil,
            footer: footer,
            backgroundColor: backgroundColor,
            sectionBackgroundColor: sectionBackgroundColor,
            rowSeparatorVisibility: rowSeparatorVisibility,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
}

extension FormViewUtil where Footer == EmptyView {
    public init(
        @ViewBuilder content: @escaping () -> Content,
        header: @escaping () -> Header,
        backgroundColor: Color = Color(uiColor: .systemGroupedBackground),
        sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground),
        rowSeparatorVisibility: Visibility = .automatic,
        accessibilityIdentifier: String? = nil
    ) {
        self.init(
            content: content,
            header: header,
            footer: nil,
            backgroundColor: backgroundColor,
            sectionBackgroundColor: sectionBackgroundColor,
            rowSeparatorVisibility: rowSeparatorVisibility,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
}

extension FormViewUtil where Header == EmptyView, Footer == EmptyView {
    public init(
        @ViewBuilder content: @escaping () -> Content,
        backgroundColor: Color = Color(uiColor: .systemGroupedBackground),
        sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground),
        rowSeparatorVisibility: Visibility = .automatic,
        accessibilityIdentifier: String? = nil
    ) {
        self.init(
            content: content,
            header: nil,
            footer: nil,
            backgroundColor: backgroundColor,
            sectionBackgroundColor: sectionBackgroundColor,
            rowSeparatorVisibility: rowSeparatorVisibility,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
}

// MARK: - Convenience: text header/footer
public struct FormViewUtilHeaderText: View {
    private let text: String

    public init(_ text: String) { self.text = text }

    public var body: some View {
        Text(text)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.primary)
            .accessibility(options: [
                .traits([.isHeader]),
                .heading(level: .h2),
                .labels(text)
            ])
    }
}

public struct FormViewUtilFooterText: View {
    private let text: String

    public init(_ text: String) { self.text = text }

    public var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension FormViewUtil where Header == FormViewUtilHeaderText, Footer == FormViewUtilFooterText {
    public init(
        @ViewBuilder content: @escaping () -> Content,
        headerText: String,
        footerText: String,
        backgroundColor: Color = Color(uiColor: .systemGroupedBackground),
        sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground),
        rowSeparatorVisibility: Visibility = .automatic,
        accessibilityIdentifier: String? = nil
    ) {
        self.init(
            content: content,
            header: { FormViewUtilHeaderText(headerText) },
            footer: { FormViewUtilFooterText(footerText) },
            backgroundColor: backgroundColor,
            sectionBackgroundColor: sectionBackgroundColor,
            rowSeparatorVisibility: rowSeparatorVisibility,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
}

extension FormViewUtil where Header == FormViewUtilHeaderText, Footer == EmptyView {
    public init(
        @ViewBuilder content: @escaping () -> Content,
        headerText: String,
        backgroundColor: Color = Color(uiColor: .systemGroupedBackground),
        sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground),
        rowSeparatorVisibility: Visibility = .automatic,
        accessibilityIdentifier: String? = nil
    ) {
        self.init(
            content: content,
            header: { FormViewUtilHeaderText(headerText) },
            footer: nil,
            backgroundColor: backgroundColor,
            sectionBackgroundColor: sectionBackgroundColor,
            rowSeparatorVisibility: rowSeparatorVisibility,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
}

extension FormViewUtil where Header == EmptyView, Footer == FormViewUtilFooterText {
    public init(
        @ViewBuilder content: @escaping () -> Content,
        footerText: String,
        backgroundColor: Color = Color(uiColor: .systemGroupedBackground),
        sectionBackgroundColor: Color = Color(uiColor: .secondarySystemGroupedBackground),
        rowSeparatorVisibility: Visibility = .automatic,
        accessibilityIdentifier: String? = nil
    ) {
        self.init(
            content: content,
            header: nil,
            footer: { FormViewUtilFooterText(footerText) },
            backgroundColor: backgroundColor,
            sectionBackgroundColor: sectionBackgroundColor,
            rowSeparatorVisibility: rowSeparatorVisibility,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }
}

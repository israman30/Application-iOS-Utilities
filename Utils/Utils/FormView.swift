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

// MARK: - Demo / sample usage
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

// MARK: - Public component
/// A lightweight, customizable `Form` wrapper that gives you:
/// - A **single** `Section` with optional header and footer
/// - A modern iOS look by default (`.insetGrouped` + grouped system backgrounds)
/// - Better UX defaults like **interactive keyboard dismissal** on iOS 16+
/// - Sensible accessibility behavior for section headers + optional identifiers
///
/// ## Why this exists
/// SwiftUI’s `Form` is powerful but tends to accumulate one-off styling across screens. `FormViewUtil`
/// centralizes a few choices so forms look and behave consistently across your app/library.
///
/// ## Accessibility notes
/// - If you provide a `header`, it is marked with `.isHeader` to improve VoiceOver navigation.
/// - Use `headerText`/`footerText` initializers when you want headings that are also rotor-friendly.
///
/// ## Usage
/// Basic (custom header/footer views):
/// ```swift
/// FormViewUtil {
///     Text("Body")
/// } header: {
///     Text("Header")
/// } footer: {
///     Text("Footer")
/// }
/// ```
///
/// Simple (consistent typography + heading semantics):
/// ```swift
/// FormViewUtil(
///     content: { Text("Body") },
///     headerText: "Header",
///     footerText: "Footer"
/// )
/// ```
///
/// Custom look (e.g. embedded in your own card container):
/// ```swift
/// FormViewUtil(
///     content: { Text("Body") },
///     headerText: "Settings",
///     backgroundColor: .clear,
///     sectionBackgroundColor: Color(uiColor: .secondarySystemBackground),
///     rowSeparatorVisibility: .hidden,
///     accessibilityIdentifier: "settings-form"
/// )
/// ```
public struct FormViewUtil<Content: View, Header: View, Footer: View>: View {
    let content: () -> Content
    var header: (() -> Header)? = nil
    var footer: (() -> Footer)? = nil

    private let backgroundColor: Color
    private let sectionBackgroundColor: Color
    private let rowSeparatorVisibility: Visibility
    private let accessibilityIdentifier: String?

    @Environment(\.colorSchemeContrast) private var colorSchemeContrast: ColorSchemeContrast
    
    /// Creates a form with a single section, plus optional header and footer.
    ///
    /// - Parameters:
    ///   - content: Section body content.
    ///   - header: Optional section header view.
    ///   - footer: Optional section footer view.
    ///   - backgroundColor: Background behind the form. Defaults to grouped system background.
    ///   - sectionBackgroundColor: Row background for the section. Defaults to secondary grouped background.
    ///   - rowSeparatorVisibility: Controls separator visibility (use `.hidden` for card-style layouts).
    ///   - accessibilityIdentifier: Optional identifier for UI tests and assistive tooling.
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
    /// Convenience initializer for forms that only need a footer.
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
    /// Convenience initializer for forms that only need a header.
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
    /// Convenience initializer for a single-section form with no header/footer.
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
/// Default header text used by the `headerText` convenience initializers.
///
/// This type exists so the convenience initializers can apply consistent typography and
/// accessibility semantics without constraining `Header == Text` (which would prevent attaching
/// modifiers that change the resulting view type).
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

/// Default footer text used by the `footerText` convenience initializers.
///
/// Uses footnote sizing + secondary color, and supports multi-line wrapping at accessibility sizes.
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
    /// Convenience initializer that renders a styled, accessible text header + footer.
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
    /// Convenience initializer that renders a styled, accessible text header.
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
    /// Convenience initializer that renders a styled footer text.
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

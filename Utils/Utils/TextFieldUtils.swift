//
//  TextFieldUtils.swift
//  Utils
//
//  Created by Israel Manzo on 1/7/24.
//

import SwiftUI

import UIKit

/// A lightweight, reusable SwiftUI text-field component with sensible UX defaults.
///
/// Use `TextFieldViewUtil` when you want a consistent input surface across screens:
/// - **Label/header**: either via the `header` view-builder or `headerText`
/// - **Leading icon**: optional SF Symbol
/// - **Supporting / error text**: shows below the field; error state also changes the border
/// - **Clear while editing**: optional trailing clear button
/// - **Secure reveal**: optional eye toggle for password fields
/// - **Focus styling**: border + shadow changes on focus
///
/// Notes:
/// - This component is UI-only; validation is up to the caller (pass `errorText` when invalid).
/// - `header` takes precedence over `headerText` when both are provided.
public struct TextFieldViewUtil<Header: View>: View {
    private let placeholder: String
    @Binding private var inputText: String

    private let font: Font
    private let headerText: String
    private let iconPlaceholder: String

    private let shadowRadius: CGFloat
    private let color: Color
    private let cornerRadius: CGFloat
    private let shadowColor: Color

    private let isSecure: Bool
    private let header: (() -> Header)?

    private let supportingText: String?
    private let errorText: String?
    private let showsClearButton: Bool
    private let showsSecureToggle: Bool

    private let autocapitalization: TextInputAutocapitalization
    private let autocorrectionDisabled: Bool
    private let submitLabel: SubmitLabel
    private let onSubmit: (() -> Void)?

    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?

    @FocusState private var isFocused: Bool
    @State private var isSecureRevealed: Bool = false
    
    enum BorderStyle: Equatable {
        case normal
        case focused
        case error
    }
    
    static func isErrored(errorText: String?) -> Bool {
        !(errorText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
    
    static func messageText(supportingText: String?, errorText: String?) -> String? {
        // Error message takes precedence over supporting text.
        if isErrored(errorText: errorText) {
            return errorText
        }
        return supportingText
    }
    
    static func borderStyle(isErrored: Bool, isFocused: Bool) -> BorderStyle {
        // Priority order: error -> focused -> default.
        if isErrored {
            return .error
        }
        if isFocused {
            return .focused
        }
        return .normal
    }
    
    static func normalizedIconName(_ iconPlaceholder: String) -> String? {
        let trimmed = iconPlaceholder.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
    
    /// Creates a styled input field.
    ///
    /// - Parameters:
    ///   - placeholder: Placeholder displayed inside the text field.
    ///   - inputText: Binding for the field text.
    ///   - font: Font applied to the input and icon.
    ///   - iconPlaceholder: Leading SF Symbol name (optional).
    ///   - headerText: Small label shown above the field when `header` is not provided.
    ///   - isSecure: Uses secure input by default, with an optional reveal toggle.
    ///   - supportingText: Optional helper text shown below the field when not errored.
    ///   - errorText: Optional validation message. When non-empty, turns the border/message red.
    ///   - showsClearButton: Shows a clear button when focused and non-empty.
    ///   - showsSecureToggle: Shows an eye button for secure fields to reveal/hide text.
    ///   - submitLabel: Keyboard submit label.
    ///   - onSubmit: Invoked when the keyboard submit action fires.
    ///   - keyboardType: iOS keyboard type (e.g. `.emailAddress`).
    ///   - textContentType: iOS text content type (e.g. `.emailAddress`, `.password`).
    ///   - header: Optional view-builder for a custom label/header above the field.
    public init(
        _ placeholder: String = "",
        inputText: Binding<String>,
        font: Font = .body,
        iconPlaceholder: String = "",
        headerText: String = "",
        shadowRadius: CGFloat = 2,
        color: Color = Color.gray.opacity(0.1),
        cornerRadius: CGFloat = 20,
        shadowColor: Color = .gray,
        isSecure: Bool = false,
        supportingText: String? = nil,
        errorText: String? = nil,
        showsClearButton: Bool = true,
        showsSecureToggle: Bool = true,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = false,
        submitLabel: SubmitLabel = .done,
        onSubmit: (() -> Void)? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        header: (() -> Header)? = nil
    ) {
        self.placeholder = placeholder
        self._inputText = inputText
        self.font = font
        self.iconPlaceholder = iconPlaceholder
        self.headerText = headerText
        self.shadowRadius = shadowRadius
        self.color = color
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.isSecure = isSecure
        self.header = header

        self.supportingText = supportingText
        self.errorText = errorText
        self.showsClearButton = showsClearButton
        self.showsSecureToggle = showsSecureToggle

        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit

        self.keyboardType = keyboardType
        self.textContentType = textContentType
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            headerView

            HStack(spacing: 10) {
                if let iconName = normalizedIconName {
                    Image(systemName: iconName)
                        .foregroundStyle(isFocused ? Color.accentColor : Color.secondary)
                        .accessibilityHidden(true)
                }

                inputView

                if showsClearButton, isFocused, !inputText.isEmpty {
                    Button {
                        inputText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear text")
                }

                if isSecure, showsSecureToggle {
                    Button {
                        isSecureRevealed.toggle()
                    } label: {
                        Image(systemName: isSecureRevealed ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isSecureRevealed ? "Hide password" : "Show password")
                }
            }
            .font(font)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(color)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: isFocused ? 2 : 1)
            }
            .shadow(color: shadowColor.opacity(isFocused ? 0.25 : 0.15), radius: shadowRadius, x: 0, y: 2)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .onTapGesture { isFocused = true }

            if let message = messageText {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(isErrored ? Color.red : .secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel(message)
            }
        }
    }

    private var isErrored: Bool {
        Self.isErrored(errorText: errorText)
    }

    private var messageText: String? {
        Self.messageText(supportingText: supportingText, errorText: errorText)
    }

    private var borderColor: Color {
        switch Self.borderStyle(isErrored: isErrored, isFocused: isFocused) {
        case .error:
            return .red
        case .focused:
            return .accentColor
        case .normal:
            return Color.secondary.opacity(0.35)
        }
    }

    private var normalizedIconName: String? {
        Self.normalizedIconName(iconPlaceholder)
    }

    @ViewBuilder
    private var headerView: some View {
        if let header {
            header()
        } else if !headerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Text(headerText)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private var inputView: some View {
        if isSecure, !isSecureRevealed {
            SecureField(placeholder, text: $inputText)
                .focused($isFocused)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled(autocorrectionDisabled)
                .submitLabel(submitLabel)
                .onSubmit { onSubmit?() }
                .keyboardType(keyboardType)
                .textContentType(textContentType ?? .password)
        } else {
            TextField(placeholder, text: $inputText)
                .focused($isFocused)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled(autocorrectionDisabled)
                .submitLabel(submitLabel)
                .onSubmit { onSubmit?() }
                .keyboardType(keyboardType)
                .textContentType(textContentType)
        }
    }
}

extension TextFieldViewUtil where Header == EmptyView {
    /// Convenience initializer when you don’t need a custom `header` view.
    public init(
        _ placeholder: String = "",
        inputText: Binding<String>,
        font: Font = .body,
        iconPlaceholder: String = "",
        headerText: String = "",
        shadowRadius: CGFloat = 2,
        color: Color = Color.gray.opacity(0.1),
        cornerRadius: CGFloat = 20,
        shadowColor: Color = .gray,
        isSecure: Bool = false,
        supportingText: String? = nil,
        errorText: String? = nil,
        showsClearButton: Bool = true,
        showsSecureToggle: Bool = true,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = false,
        submitLabel: SubmitLabel = .done,
        onSubmit: (() -> Void)? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) {
        self.init(
            placeholder,
            inputText: inputText,
            font: font,
            iconPlaceholder: iconPlaceholder,
            headerText: headerText,
            shadowRadius: shadowRadius,
            color: color,
            cornerRadius: cornerRadius,
            shadowColor: shadowColor,
            isSecure: isSecure,
            supportingText: supportingText,
            errorText: errorText,
            showsClearButton: showsClearButton,
            showsSecureToggle: showsSecureToggle,
            autocapitalization: autocapitalization,
            autocorrectionDisabled: autocorrectionDisabled,
            submitLabel: submitLabel,
            onSubmit: onSubmit,
            keyboardType: keyboardType,
            textContentType: textContentType,
            header: nil
        )
    }
}

// MARK: - Usage
/// A small, interactive view that demonstrates how to use `TextFieldViewUtil`.
///
/// This is intended for previews / manual QA:
/// - Toggle error state to see validation styling.
/// - Toggle disabled state to verify readability and affordances.
struct TextFieldViewUtilSampleView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    @State private var showError: Bool = false
    @State private var isDisabled: Bool = false

    private var emailError: String? {
        guard showError else { return nil }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Email is required." }
        if !email.contains("@") { return "Please enter a valid email address." }
        return nil
    }

    private var passwordError: String? {
        guard showError else { return nil }
        if password.count < 8 { return "Password must be at least 8 characters." }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TextFieldViewUtil")
                .font(.title2.weight(.semibold))

            VStack(alignment: .leading, spacing: 10) {
                Toggle("Show error state", isOn: $showError)
                Toggle("Disable fields", isOn: $isDisabled)
            }

            Divider()

            TextFieldViewUtil(
                "Email",
                inputText: $email,
                iconPlaceholder: "envelope",
                headerText: "Email",
                shadowRadius: 6,
                color: Color.secondary.opacity(0.08),
                cornerRadius: 14,
                shadowColor: .black,
                supportingText: "We’ll only use this to contact you.",
                errorText: emailError,
                submitLabel: .next,
                keyboardType: .emailAddress,
                textContentType: .emailAddress
            )
            .disabled(isDisabled)

            TextFieldViewUtil(
                "Password",
                inputText: $password,
                iconPlaceholder: "lock",
                headerText: "Password",
                shadowRadius: 6,
                color: Color.secondary.opacity(0.08),
                cornerRadius: 14,
                shadowColor: .black,
                isSecure: true,
                supportingText: "Use 8+ characters.",
                errorText: passwordError,
                submitLabel: .done,
                keyboardType: .default,
                textContentType: .password
            )
            .disabled(isDisabled)

            Button("Validate") {
                showError = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(isDisabled)

            Spacer(minLength: 0)
        }
        .padding()
    }
}

#if DEBUG
struct TextFieldViewUtilSampleView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldViewUtilSampleView()
    }
}
#endif

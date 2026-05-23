## Text field

- **Source**: [`Utils/Utils/TextFieldUtils.swift`](../Utils/Utils/TextFieldUtils.swift)
- **Sample view**: [`TextFieldViewUtilSampleView` preview](../Utils/Utils/TextFieldUtils.swift#L293-L384)

### Import

```swift
import Utils
```

### Use `TextFieldViewUtil`

```swift
@State private var email = ""
@State private var password = ""

TextFieldViewUtil(
    "Email",
    inputText: $email,
    iconPlaceholder: "envelope",
    headerText: "Email",
    supportingText: "We’ll only use this to contact you.",
    keyboardType: .emailAddress,
    textContentType: .emailAddress
)

TextFieldViewUtil(
    "Password",
    inputText: $password,
    iconPlaceholder: "lock",
    headerText: "Password",
    isSecure: true,
    supportingText: "Use 8+ characters.",
    textContentType: .password
)
```

### Validation (error state)

Pass an `errorText` string when validation fails:

```swift
TextFieldViewUtil(
    "Email",
    inputText: $email,
    iconPlaceholder: "envelope",
    headerText: "Email",
    errorText: email.contains("@") ? nil : "Please enter a valid email address."
)
```


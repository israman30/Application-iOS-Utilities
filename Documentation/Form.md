## Forms

- **Source**: [`Utils/Utils/FormView.swift`](../Utils/Utils/FormView.swift)
- **Sample view**: [`FormView` preview](../Utils/Utils/FormView.swift#L13-L128)

### Import

```swift
import Utils
```

### Use `FormViewUtil` (simple initializer)

```swift
FormViewUtil(
    content: {
        Text("Body")
    },
    headerText: "Header",
    footerText: "Footer"
)
```

### Custom header/footer views

```swift
FormViewUtil {
    Text("Body")
} header: {
    FormViewUtilHeaderText("Account")
} footer: {
    FormViewUtilFooterText("These settings apply to your current device.")
}
```


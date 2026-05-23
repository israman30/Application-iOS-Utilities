## Accessibility utilities

- **Source**: [`Utils/Utils/AccessibilityView.swift`](../Utils/Utils/AccessibilityView.swift)
- **Sample view**: [`AccessibilityView` preview](../Utils/Utils/AccessibilityView.swift#L13-L299)

### Import

```swift
import Utils
```

### Use `.accessibility(options:)`

```swift
Text("Main Heading")
    .font(.largeTitle)
    .accessibility(options: [
        .traits([.isHeader]),
        .heading(level: .h1),
        .labels("Main heading")
    ])
```

### Tip

If you want a practical checklist screen to compare against your own UI, use the sample display view (`AccessibilityView`) directly in a debug menu or preview.


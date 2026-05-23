## Buttons

- **Source**: [`Utils/Utils/ButtonView.swift`](../Utils/Utils/ButtonView.swift)
- **Sample view**: [`ButtonView` preview](../Utils/Utils/ButtonView.swift#L11-L67)

### Import

If you integrated the framework target:

```swift
import Utils
```

If you copied files into your app target, no module import is needed.

### Use `ButtonViewUtils`

```swift
@State private var isUploading = false

ButtonViewUtils(label: "Delete", icon: "trash") {
    // action
}
.buttonStyle(.dangerUtil)

ButtonViewUtils(
    title: "Upload",
    icon: "arrow.up.circle.fill",
    isLoading: isUploading,
    onLongPress: {
        // optional secondary action
    }
) {
    // action
}
.buttonStyle(.blueUtil)
```

### Use `.utilButtonType(...)` (system `Button` modifier)

```swift
Button("Primary") { }
    .utilButtonType(.primary)
```

### Styles available

- `.dangerUtil`
- `.warningUtil`
- `.grayUtil`
- `.greenUtil`
- `.blueUtil`
- `.clearUtil`


## Floating action button

- **Source**: [`Utils/Utils/FloatingButtonView.swift`](../Utils/Utils/FloatingButtonView.swift)
- **Sample view**: [`FloatingButtonView` preview](../Utils/Utils/FloatingButtonView.swift#L11-L79)

### Import

```swift
import Utils
```

### Use `FloatingButtonUtilsView`

```swift
@State private var isCreating = false

FloatingButtonUtilsView(
    title: "Add item",
    alignment: .trailing, // or `.leading`
    tint: .blue,
    icon: "plus",
    isLoading: isCreating,
    onLongPress: {
        // optional secondary action
    }
) {
    // action
}
```

### Notes

- `title` is used for accessibility labeling (keep it short and action-oriented).
- `isLoading` disables interaction and swaps the icon for a spinner.


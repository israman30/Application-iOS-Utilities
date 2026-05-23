## Tooltip / activity pill

- **Source**: [`Utils/Utils/TooltipView.swift`](../Utils/Utils/TooltipView.swift)
- **Sample view**: [`TooltipView` preview](../Utils/Utils/TooltipView.swift#L11-L75)

### Import

```swift
import Utils
```

### Use `ActivityItemUtils`

```swift
ActivityItemUtils("12", type: .left, tint: .orange, icon: {
    Image(systemName: "bubble.fill")
})
```

### Interactive usage (tap + long-press)

```swift
ActivityItemUtils(
    "Tap me",
    type: .bottom,
    tint: .blue,
    onTap: {
        // tap
    },
    onLongPress: {
        // long press
    },
    pressHaptic: .light
) {
    Image(systemName: "hand.tap.fill")
}
```


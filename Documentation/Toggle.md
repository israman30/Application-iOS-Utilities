## Toggle

- **Source**: [`Utils/Utils/ToggleView.swift`](../Utils/Utils/ToggleView.swift)
- **Sample view**: [`ToggleView` preview](../Utils/Utils/ToggleView.swift#L13-L50)

### Import

```swift
import Utils
```

### Use `ToggleViewUtils`

```swift
@State private var isOn = false

ToggleViewUtils(
    title: "Enable feature",
    subtitle: "Improves recommendations and sync.",
    icon: "sparkles",
    isOn: $isOn,
    tintColor: .blue,
    usesHaptics: true
)
```


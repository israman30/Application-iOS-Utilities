## Stepper

- **Source**: [`Utils/Utils/StepperView.swift`](../Utils/Utils/StepperView.swift)
- **Sample view**: [`StepperView` preview](../Utils/Utils/StepperView.swift#L10-L58)

### Import

```swift
import Utils
```

### Use `StepperViewUtils`

```swift
@State private var value = 0

StepperViewUtils(
    title: "Quantity",
    value: $value,
    min: 0,
    max: 100,
    step: 1,
    showsValue: true,
    tintColor: .blue
)
```

### Notes

- `min`/`max` are normalized if passed in reversed.
- `step <= 0` is treated as `1`.


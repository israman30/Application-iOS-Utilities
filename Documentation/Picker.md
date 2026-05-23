## Pickers

- **Source**: [`Utils/Utils/PickerView.swift`](../Utils/Utils/PickerView.swift)
- **Sample view**: [`PickerView` preview](../Utils/Utils/PickerView.swift#L10-L70)

### Import

```swift
import Utils
```

## `PickerViewUtils`

```swift
@State private var selection = "Car"
let options = ["Car", "Plane", "Boat", "Train"]

PickerViewUtils(
    titleKey: "Transport",
    selection: $selection,
    options: options,
    showsSelectedValue: true,
    tintColor: .blue,
    usesHaptics: true
)
.pickerStyle(.menu) // choose the style at the call site
```

## `DatePickerViewUtils`

```swift
@State private var date = Date()

DatePickerViewUtils(
    labelKey: "Date",
    date: $date,
    valuePrefix: "Selected:",
    displayedComponents: [.date],
    alignment: .leading
)
```


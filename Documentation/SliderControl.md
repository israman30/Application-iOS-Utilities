## Slider with controls

- **Source**: [`Utils/Utils/SliderControlView.swift`](../Utils/Utils/SliderControlView.swift)
- **Sample view**: [`SliderControlView` preview](../Utils/Utils/SliderControlView.swift#L11-L55)

### Import

```swift
import Utils
```

### Use `SliderControlViewUtils`

```swift
@State private var sliderValue: Double = 50

SliderControlViewUtils(
    titleKey: "Brightness",
    value: $sliderValue,
    min: 0,
    max: 100,
    step: 1,
    minIcon: "minus",
    maxIcon: "plus",
    minimumValueLabel: "0",
    maximumValueLabel: "100",
    showsValue: true,
    tintColor: .blue
)
```

### Notes

- Use `minTapAction` / `maxTapAction` if you want custom +/- behavior.
- Use `onEditingChanged` if you need to detect when the user starts/stops sliding.


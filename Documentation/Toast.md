## Toast

- **Source**: [`Utils/Utils/ToastView.swift`](../Utils/Utils/ToastView.swift)
- **Sample view**: [`ToastViewSampleView` preview](../Utils/Utils/ToastView.swift#L539-L838)

### Import

```swift
import Utils
```

### Recommended usage: `.toast(...)` overlay modifier

```swift
@State private var showToast = false

VStack {
    Button("Save") { showToast = true }
}
.toast(
    text: "Saved",
    isVisible: $showToast,
    title: "Success",
    style: .success,
    position: .top,
    showsCloseButton: true,
    actionTitle: "Undo",
    action: {
        // optional action
    },
    haptic: .success
)
```

### Notes

- Prefer the modifier when you want to show a toast from any screen without manually layering `ToastView`.
- The sample view demonstrates style, position, auto-dismiss timing, swipe/tap dismiss, and VoiceOver announcement behavior.


## Navigation coordinator (reference implementation)

- **Source**: [`Utils/Utils/NavigationCoordinator.swift`](../Utils/Utils/NavigationCoordinator.swift)
- **Sample view**: [`ContentView` preview](../Utils/Utils/NavigationCoordinator.swift#L407-L422)

### Import

```swift
import Utils
```

### What this is

This file contains a coordinator-style `NavigationStack` reference implementation showing:

- Navigation history
- “Replace stack” support
- Basic deep linking via `URLComponents`

### How to use it in your app

This is intended to be **copied and adapted**:

- Copy `Utils/Utils/NavigationCoordinator.swift` into your app target
- Replace `NavigationDestination` and placeholder views with your own destinations/views
- Keep the coordinator API you like (`navigate`, `navigateBack`, deep-link parsing, etc.)


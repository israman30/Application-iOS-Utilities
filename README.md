# Application-iOS-Utilities

Reusable SwiftUI utilities (buttons, text fields, toast, grid layouts, ratings, etc.) plus a few reference/demo screens you can copy into your app.

> [!NOTE]
> This project currently supports **SwiftUI** only.

## 📦 Installation

This repository ships an Xcode framework project (`Utils/Utils.xcodeproj`). There is currently **no** `Package.swift`, so Swift Package Manager isn’t available out of the box.

### Option A: Add the `Utils` framework (Xcode subproject)

1. Clone the repository:
   ```bash
   git clone https://github.com/israman30/Application-iOS-Utilities.git
   ```
2. In Xcode, drag `Utils/Utils.xcodeproj` into your app project.
3. Select your app target → **General** → **Frameworks, Libraries, and Embedded Content**.
4. Add `Utils.framework` and choose the appropriate embed option for your app.

### Option B: Copy the source files (quickest way to use everything)

Copy the Swift files from `Utils/Utils/` into your app target (for example, if you want to tweak styles or avoid framework integration).

> Some types in this repo are marked `public` but currently rely on **internal initializers or internal helper enums**. Copying the source files is the most frictionless way to use all utilities immediately. If you prefer consuming `Utils` as a compiled framework, consider exposing `public init` where needed.

## 🚀 Getting Started

If you integrated the framework target, import the module:

```swift
import Utils
```

## 📱 Components

### Buttons (`ButtonViewUtils`, button styles, and system button modifier)

```swift
ButtonViewUtils(label: "Tap here", icon: "xmark.circle") {
    // action
}
.buttonStyle(.dangerUtil)

Button("Primary") { }
    .utilButtonType(.primary)

Button("Secondary") { }
    .utilButtonType(.secondary)

Button("Destructive") { }
    .utilButtonType(.destructive)
```

**Available `ButtonStyle`s**
- `.dangerUtil`
- `.warningUtil`
- `.grayUtil`
- `.greenUtil`
- `.blueUtil`
- `.clearUtil`

### Toast (`ToastView`)

```swift
@State private var showToast = false

ToastView(
    text: "Operation completed successfully!",
    isVisible: $showToast,
    delayedAnimation: 3.0,
    animationDuration: 0.3
)
```

### Floating Action Button (`FloatingButtonUtilsView`)

```swift
FloatingButtonUtilsView {
    // action
}
```

### Text field (`TextFieldViewUtil`)

```swift
@State private var email = ""
@State private var password = ""

TextFieldViewUtil("Email", inputText: $email, iconPlaceholder: "envelope.fill") {
    Text("Email Address")
}

TextFieldViewUtil("Password", inputText: $password, iconPlaceholder: "lock.fill", isSecure: true) {
    Text("Password")
}
```

### Ratings (`RatingStarsView`, `RatingHeartsView`)

```swift
RatingStarsView(rating: 3.5, maxRating: 5)
RatingHeartsView(rating: 4.0, maxRating: 5)
```

### Slider with controls (`SliderControlViewUtils`)

`SliderControlViewUtils` supports optional icons with tap actions and an `onEditingChanged` callback.

```swift
@State private var sliderValue: Double = 50

SliderControlViewUtils(
    value: $sliderValue,
    min: 0,
    max: 100,
    minIcon: "minus.circle.fill",
    maxIcon: "plus.circle.fill",
    onEditingChanged: { isEditing in
        // editing started/ended
    },
    minTapAction: { sliderValue -= 1 },
    maxTapAction: { sliderValue += 1 }
)
```

### Grid layouts (`GridView`, `ScrollGridView`)

```swift
// Generic scrollable grid using `.flexible()` cells.
ScrollGridView(columns: 2) {
    ForEach(0..<10) { index in
        Text("Item \(index)")
            .padding(8)
            .background(Color.blue.opacity(0.15))
            .cornerRadius(8)
    }
}
```

```swift
// Square-celled vertical grid (great for thumbnails).
GridView(items: Array(0..<9), totalCount: 9, columns: 3) { item in
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.blue.opacity(0.15))
        .overlay(Text("\(item)"))
}
```

### Stepper (`StepperViewUtils`)

```swift
@State private var value = 0

StepperViewUtils(title: "Quantity", value: $value, min: 0, max: 100, step: 1) {
    // onUpdate
}
```

### Pickers (`PickerViewUtils`, `DatePickerViewUtils`)

```swift
@State private var selection = "Car"
let options = ["Car", "Plane", "Boat", "Train"]

PickerViewUtils(titleKey: "Select a transport", selection: $selection, opions: options) {
    // onUpdate
}
.pickerStyle(.wheel)
```

```swift
@State private var date = Date()

DatePickerViewUtils(
    labelKey: "Select a date",
    date: $date,
    label: "Selected:",
    alignment: .leading
)
```

### Toggle (`ToggleViewUtils`)

```swift
@State private var isOn = false

ToggleViewUtils(titleKey: "Enable feature", isOn: $isOn)
```

### Forms (`FormViewUtil`)

```swift
FormViewUtil {
    Text("Body")
} header: {
    Text("Header")
} footer: {
    Text("Footer")
}
```

### Like button (`HeartLikeView`)

```swift
@State private var isLiked = false
HeartLikeView(isLiked: $isLiked)
```

### Tooltip / activity pill (`ActivityItemUtils`)

```swift
ActivityItemUtils("12", type: .left) {
    Image(systemName: "bubble.fill")
}
```

### Accessibility utilities (`.accessibility(options:)`)

```swift
Text("Main Heading")
    .font(.largeTitle)
    .accessibility(options: [
        .traits([.isHeader]),
        .heading(level: .h1),
        .labels("Main heading")
    ])
```

**Available options**
- `.traits([AccessibilityTraits])`
- `.labels(String)`
- `.value(String)`
- `.hint(String)`
- `.accessibilityHidden`
- `.behaviour(children: AccessibilityChildBehavior)` (`.combine`, `.ignore`, `.contain`)
- `.heading(level: AccessibilityHeadingLevel)` (`.h1` ... `.h6`)

## 🧭 Navigation coordinator (reference implementation)

`Utils/Utils/NavigationCoordinator.swift` contains a coordinator-style `NavigationStack` reference, including:
- Navigation history
- “replace stack” support
- Basic deep linking via `URLComponents`

It uses the Observation framework (`@Observable`) and includes placeholder views to demonstrate navigation. If you want to reuse it in your app, copy the file and replace `NavigationDestination` and the placeholder views with your own.

## 📋 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 🤝 Contributing

Contributions are welcome. Please open an issue or submit a Pull Request.

## 📄 License

MIT License. See `LICENSE`.

---

&copy; 2026 Israel Manzo. All rights reserved.
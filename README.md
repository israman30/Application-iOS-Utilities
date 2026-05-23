# Application-iOS-Utilities

Reusable **SwiftUI** utilities (buttons, text fields, toast, grids, ratings, pickers, steppers, etc.) plus a few **copy/paste-friendly demo screens** you can use as reference when building your own UI.

> [!NOTE]
> This project currently supports **SwiftUI** only (iOS 17+).

## ✨ What you get

- **Drop-in SwiftUI components**: `ToastView`, `TextFieldViewUtil`, `ButtonViewUtils`, `FloatingButtonUtilsView`, etc.
- **Settings-style controls**: `ToggleViewUtils`, `StepperViewUtils`, `SliderControlViewUtils`, `PickerViewUtils`, `DatePickerViewUtils`.
- **Layout helpers**: `ScrollGridView` (lazy vertical/horizontal) and `GridView` (square cells).
- **Reference screens**: accessibility checklist screen and a navigation coordinator reference implementation.

## 📋 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

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

Copy the Swift files from `Utils/Utils/` into your app target (useful if you want to tweak styling, or if you hit access-control friction consuming it as a compiled framework).

## 🚀 Quick start

If you integrated the framework target, import the module where you use the components:

```swift
import Utils
```

Then use any component like you would in a normal SwiftUI view.

## 🖼️ Sample displays (component gallery)

Every component file includes a **sample display** you can run in Xcode previews (either a `*SampleView` or a small demo `*View` + `*_Previews`).

Open `Utils/Utils.xcodeproj`, then open any file under `Utils/Utils/` and use the SwiftUI Canvas preview.

- **Buttons sample**: [`ButtonView` preview](Utils/Utils/ButtonView.swift#L11-L67)
- **Floating button sample**: [`FloatingButtonView` preview](Utils/Utils/FloatingButtonView.swift#L11-L79)
- **Toast sample**: [`ToastViewSampleView` preview](Utils/Utils/ToastView.swift#L539-L838)
- **Text field sample**: [`TextFieldViewUtilSampleView` preview](Utils/Utils/TextFieldUtils.swift#L293-L384)
- **Ratings (stars)**: [`RatingStarsSampleView` preview](Utils/Utils/RatingStartsView.swift#L10-L133)
- **Ratings (hearts)**: [`RatingHeartsSampleView` preview](Utils/Utils/RatingHeartsView.swift#L10-L131)
- **Slider sample**: [`SliderControlView` preview](Utils/Utils/SliderControlView.swift#L11-L55)
- **Stepper sample**: [`StepperView` preview](Utils/Utils/StepperView.swift#L10-L58)
- **Pickers sample**: [`PickerView` preview](Utils/Utils/PickerView.swift#L10-L70)
- **Toggle sample**: [`ToggleView` preview](Utils/Utils/ToggleView.swift#L13-L50)
- **Tooltip / activity pill sample**: [`TooltipView` preview](Utils/Utils/TooltipView.swift#L11-L75)
- **Grid (scrollable)**: [`ScrollGridViewSampleView` preview](Utils/Utils/GridView.swift#L106-L211)
- **Grid (square cells)**: [`GridViewSampleView` preview](Utils/Utils/SquareGridView.swift#L92-L168)
- **Like button sample**: [`HeartLikeSampleView` preview](Utils/Utils/HeartLikeView.swift#L10-L102)
- **Forms sample**: [`FormView` preview](Utils/Utils/FormView.swift#L13-L128)
- **Accessibility reference screen**: [`AccessibilityView` preview](Utils/Utils/AccessibilityView.swift#L13-L299)
- **Navigation coordinator reference**: [`ContentView` preview](Utils/Utils/NavigationCoordinator.swift#L407-L422)

## 📱 Components (usage snippets)

Each section below includes a minimal snippet plus a link to the **sample display** in the repo.

### Buttons (`ButtonViewUtils`, styles, and `.utilButtonType`)

- **Source**: [`Utils/Utils/ButtonView.swift`](Utils/Utils/ButtonView.swift)
- **Sample display**: [`ButtonView` preview](Utils/Utils/ButtonView.swift#L11-L67)

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

Button("Primary") { }
    .utilButtonType(.primary)
```

**Available `ButtonStyle`s**
- `.dangerUtil`
- `.warningUtil`
- `.grayUtil`
- `.greenUtil`
- `.blueUtil`
- `.clearUtil`

### Floating Action Button (`FloatingButtonUtilsView`)

- **Source**: [`Utils/Utils/FloatingButtonView.swift`](Utils/Utils/FloatingButtonView.swift)
- **Sample display**: [`FloatingButtonView` preview](Utils/Utils/FloatingButtonView.swift#L11-L79)

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

### Toast (`ToastView` + `.toast(...)` modifier)

- **Source**: [`Utils/Utils/ToastView.swift`](Utils/Utils/ToastView.swift)
- **Sample display**: [`ToastViewSampleView` preview](Utils/Utils/ToastView.swift#L539-L838)

Recommended (overlay modifier):

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
    haptic: .success
)
```

### Text field (`TextFieldViewUtil`)

- **Source**: [`Utils/Utils/TextFieldUtils.swift`](Utils/Utils/TextFieldUtils.swift)
- **Sample display**: [`TextFieldViewUtilSampleView` preview](Utils/Utils/TextFieldUtils.swift#L293-L384)

```swift
@State private var email = ""
@State private var password = ""

TextFieldViewUtil(
    "Email",
    inputText: $email,
    iconPlaceholder: "envelope",
    headerText: "Email",
    supportingText: "We’ll only use this to contact you.",
    keyboardType: .emailAddress,
    textContentType: .emailAddress
)

TextFieldViewUtil(
    "Password",
    inputText: $password,
    iconPlaceholder: "lock",
    headerText: "Password",
    isSecure: true,
    supportingText: "Use 8+ characters.",
    textContentType: .password
)
```

### Ratings (`RatingStarsView`, `RatingHeartsView`)

- **Stars source**: [`Utils/Utils/RatingStartsView.swift`](Utils/Utils/RatingStartsView.swift)
- **Stars sample display**: [`RatingStarsSampleView` preview](Utils/Utils/RatingStartsView.swift#L10-L133)
- **Hearts source**: [`Utils/Utils/RatingHeartsView.swift`](Utils/Utils/RatingHeartsView.swift)
- **Hearts sample display**: [`RatingHeartsSampleView` preview](Utils/Utils/RatingHeartsView.swift#L10-L131)

```swift
RatingStarsView(rating: 3.5, maxRating: 5)
    .frame(height: 28)

RatingHeartsView(rating: 4.0, maxRating: 5)
    .frame(height: 28)
```

### Slider with controls (`SliderControlViewUtils`)

- **Source**: [`Utils/Utils/SliderControlView.swift`](Utils/Utils/SliderControlView.swift)
- **Sample display**: [`SliderControlView` preview](Utils/Utils/SliderControlView.swift#L11-L55)

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

### Stepper (`StepperViewUtils`)

- **Source**: [`Utils/Utils/StepperView.swift`](Utils/Utils/StepperView.swift)
- **Sample display**: [`StepperView` preview](Utils/Utils/StepperView.swift#L10-L58)

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

### Pickers (`PickerViewUtils`, `DatePickerViewUtils`)

- **Source**: [`Utils/Utils/PickerView.swift`](Utils/Utils/PickerView.swift)
- **Sample display**: [`PickerView` preview](Utils/Utils/PickerView.swift#L10-L70)

```swift
@State private var selection = "Car"
let options = ["Car", "Plane", "Boat", "Train"]

PickerViewUtils(
    titleKey: "Transport",
    selection: $selection,
    options: options,
    tintColor: .blue,
    usesHaptics: true
)
.pickerStyle(.menu) // or `.wheel`, `.palette`, ...
```

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

### Toggle (`ToggleViewUtils`)

- **Source**: [`Utils/Utils/ToggleView.swift`](Utils/Utils/ToggleView.swift)
- **Sample display**: [`ToggleView` preview](Utils/Utils/ToggleView.swift#L13-L50)

```swift
@State private var isOn = false

ToggleViewUtils(
    title: "Enable feature",
    subtitle: "Improves recommendations and sync.",
    icon: "sparkles",
    isOn: $isOn,
    tintColor: .blue
)
```

### Forms (`FormViewUtil`)

- **Source**: [`Utils/Utils/FormView.swift`](Utils/Utils/FormView.swift)
- **Sample display**: [`FormView` preview](Utils/Utils/FormView.swift#L13-L128)

```swift
FormViewUtil(
    content: { Text("Body") },
    headerText: "Header",
    footerText: "Footer"
)
```

Custom header/footer views (including `FormViewUtilHeaderText` / `FormViewUtilFooterText`):

```swift
FormViewUtil {
    Text("Body")
} header: {
    FormViewUtilHeaderText("Account")
} footer: {
    FormViewUtilFooterText("These settings apply to your current device.")
}
```

### Grid layouts (`ScrollGridView`, `GridView`, `SquareGridView` alias)

- **Scrollable grid source**: [`Utils/Utils/GridView.swift`](Utils/Utils/GridView.swift)
- **Scrollable grid sample display**: [`ScrollGridViewSampleView` preview](Utils/Utils/GridView.swift#L106-L211)
- **Square grid source**: [`Utils/Utils/SquareGridView.swift`](Utils/Utils/SquareGridView.swift)
- **Square grid sample display**: [`GridViewSampleView` preview](Utils/Utils/SquareGridView.swift#L92-L168)

```swift
ScrollGridView(.vertical, columns: 2) {
    ForEach(0..<10) { index in
        Text("Item \(index)")
            .padding(8)
            .background(Color.blue.opacity(0.15))
            .cornerRadius(8)
    }
}
```

```swift
GridView(items: Array(0..<9), totalCount: 9, columns: 3) { item in
    RoundedRectangle(cornerRadius: 8)
        .fill(Color.blue.opacity(0.15))
        .overlay(Text("\(item)"))
}
```

Legacy alias:

```swift
SquareGridView(items: Array(0..<9), totalCount: 9, columns: 3) { item in
    Color.blue.opacity(0.15).overlay(Text("\(item)"))
}
```

### Like button (`HeartLikeView`)

- **Source**: [`Utils/Utils/HeartLikeView.swift`](Utils/Utils/HeartLikeView.swift)
- **Sample display**: [`HeartLikeSampleView` preview](Utils/Utils/HeartLikeView.swift#L10-L102)

```swift
@State private var isLiked = false
HeartLikeView(isLiked: $isLiked)
```

### Tooltip / activity pill (`ActivityItemUtils`)

- **Source**: [`Utils/Utils/TooltipView.swift`](Utils/Utils/TooltipView.swift)
- **Sample display**: [`TooltipView` preview](Utils/Utils/TooltipView.swift#L11-L75)

```swift
ActivityItemUtils("12", type: .left, tint: .orange, icon: {
    Image(systemName: "bubble.fill")
})
```

### Accessibility utilities (`.accessibility(options:)`)

- **Source**: [`Utils/Utils/AccessibilityView.swift`](Utils/Utils/AccessibilityView.swift)
- **Sample display**: [`AccessibilityView` preview](Utils/Utils/AccessibilityView.swift#L13-L299)

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

- **Source**: [`Utils/Utils/NavigationCoordinator.swift`](Utils/Utils/NavigationCoordinator.swift)
- **Sample display**: [`ContentView` preview](Utils/Utils/NavigationCoordinator.swift#L407-L422)

`Utils/Utils/NavigationCoordinator.swift` contains a coordinator-style `NavigationStack` reference, including:
- Navigation history
- “replace stack” support
- Basic deep linking via `URLComponents`

It uses the Observation framework (`@Observable`) and includes placeholder views to demonstrate navigation. If you want to reuse it in your app, copy the file and replace `NavigationDestination` and the placeholder views with your own.

## 🤝 Contributing

Contributions are welcome. Please open an issue or submit a Pull Request.

## 📄 License

MIT License. See `LICENSE`.

---

&copy; 2026 Israel Manzo. All rights reserved.
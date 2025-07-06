# Application-iOS-Utilities

A comprehensive SwiftUI utilities framework providing reusable components for iOS applications.

> [!NOTE] 
> This framework currently supports **SwiftUI** only.

## 📦 Installation

### Using Swift Package Manager in Xcode

1. Open your Xcode project
2. Go to **File** → **Add Package Dependencies...**
3. In the search bar, paste the repository URL:
   ```
   https://github.com/yourusername/Application-iOS-Utilities.git
   ```
4. Click **Add Package**
5. Select your target and click **Add Package**

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Application-iOS-Utilities.git
   ```
2. Drag the `Utils.xcodeproj` file into your Xcode project
3. Add the Utils framework to your target's dependencies

## 🚀 Getting Started

### Import the Framework

Add the following import statement to your SwiftUI views:

```swift
import Utils
```

## 📱 Components

### ButtonViewUtils

Customizable button component with various styles and icons.

```swift
// Basic button with icon
ButtonViewUtils(label: "Tap here", icon: "xmark.circle") {
    // Your action here
}
.buttonStyle(.dangerUtil)

// System button types
Button("Success") {
    // action
}
.utilButtonType(.primary)

Button("Secondary") {
    // action
}
.utilButtonType(.secondary)

Button("Destructive") {
    // action
}
.utilButtonType(.destructive)
```

**Available Button Styles:**
- `.dangerUtil` - Red danger style
- `.warningUtil` - Orange warning style
- `.grayUtil` - Gray style
- `.greenUtil` - Green style
- `.blueUtil` - Blue style
- `.clearUtil` - Clear style

### ToastView

Display temporary notification messages with auto-dismiss functionality.

```swift
@State private var showToast = false

ToastView(
    text: "Operation completed successfully!",
    isVisible: $showToast,
    delayedAnimation: 3.0,
    animationDuration: 0.3
)
```

### FloatingButtonUtilsView

Floating action button that can be positioned on screen.

```swift
FloatingButtonUtilsView(
    alignment: .trailing,
    color: .blue,
    icon: "plus"
) {
    // Your action here
}
```

**Alignment Options:**
- `.leading` - Left side of screen
- `.trailing` - Right side of screen

### TextFieldViewUtil

Enhanced text field with custom styling and optional headers.

```swift
@State private var email = ""
@State private var password = ""

// Basic text field
TextFieldViewUtil("Enter email", inputText: $email) {
    Text("Email Address")
}

// Secure text field with icon
TextFieldViewUtil(
    "Enter password",
    inputText: $password,
    iconPlaceholder: "lock.fill",
    isSecure: true
) {
    Text("Password")
}
```

### RatingStarsView

Star rating component with customizable rating display.

```swift
RatingStarsView(rating: 3.5, maxRating: 5)
```

### RatingHeartsView

Heart rating component for like/dislike functionality.

```swift
RatingHeartsView(rating: 4, maxRating: 5)
```

### SliderControlViewUtils

Advanced slider with custom controls and icons.

```swift
@State private var sliderValue: Double = 50

SliderControlViewUtils(
    value: $sliderValue,
    min: 0,
    max: 100,
    minIcon: "minus.circle.fill",
    maxIcon: "plus.circle.fill"
) { _ in
    // On value update
} minTapAction: {
    sliderValue -= 1
} maxTapAction: {
    sliderValue += 1
}
```

### GridView

Flexible grid layout component supporting both vertical and horizontal orientations.

```swift
// Vertical grid with 2 columns
GridView(columns: 2) {
    ForEach(0..<10) { index in
        Text("Item \(index)")
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
    }
}

// Horizontal grid with 3 rows
GridView(.horizontal, rows: 3) {
    ForEach(0..<6) { index in
        Text("Item \(index)")
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(8)
    }
}
```

### SquareGridView

Square grid layout for image galleries or card layouts.

```swift
SquareGridView(columns: 3) {
    ForEach(0..<9) { index in
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.blue.opacity(0.2))
            .aspectRatio(1, contentMode: .fit)
    }
}
```

### StepperView

Custom stepper component with increment/decrement functionality.

```swift
@State private var stepperValue = 0

StepperView(value: $stepperValue, range: 0...10)
```

### PickerView

Enhanced picker component with custom styling.

```swift
@State private var selectedOption = "Option 1"
let options = ["Option 1", "Option 2", "Option 3"]

PickerView(
    selection: $selectedOption,
    options: options
)
```

### ToggleView

Custom toggle switch component.

```swift
@State private var isEnabled = false

ToggleView(isOn: $isEnabled)
```

### FormView

Form container with organized layout.

```swift
FormView {
    TextFieldViewUtil("Name", inputText: $name) {
        Text("Full Name")
    }
    
    TextFieldViewUtil("Email", inputText: $email) {
        Text("Email Address")
    }
    
    ButtonViewUtils(label: "Submit", icon: "checkmark") {
        // Submit action
    }
    .buttonStyle(.blueUtil)
}
```

### HeartLikeView

Animated heart like button.

```swift
@State private var isLiked = false

HeartLikeView(isLiked: $isLiked)
```

### AccessibilityView

Accessibility-focused view components with advanced accessibility options.

```swift
// Basic accessibility usage
AccessibilityView {
    Text("Accessible content")
}
.accessibilityLabel("Important information")

// Advanced accessibility with options modifier
Text("Main Heading")
    .font(.largeTitle)
    .accessibility(options: [
        .traits([.isHeader]),
        .heading(level: .h1)
    ])

// Slider with comprehensive accessibility
Slider(value: $sliderValue)
    .accessibility(options: [
        .labels("Volume Control"),
        .value("\(sliderValue)"),
        .hint("Drag to adjust volume level"),
        .behaviour(children: .ignore)
    ])

// Container with combined accessibility behavior
VStack {
    Text("Item 1")
    Text("Item 2")
    Text("Item 3")
}
.accessibility(options: [.behaviour(children: .combine)])
```

**Available Accessibility Options:**

- **`.traits([AccessibilityTraits])`** - Add accessibility traits like `.isHeader`, `.isButton`, `.isLink`
- **`.labels(String)`** - Set accessibility label for screen readers
- **`.value(String)`** - Set accessibility value (useful for sliders, progress bars)
- **`.hint(String)`** - Provide helpful hints for screen reader users
- **`.accessibilityHidden`** - Hide element from accessibility services
- **`.behaviour(children: AccessibilityChildBehavior)`** - Control how child elements are handled
  - `.combine` - Combine all children into single accessibility element
  - `.ignore` - Ignore child elements in accessibility
  - `.contain` - Contain child elements (default behavior)
- **`.heading(level: AccessibilityHeadingLevel)`** - Set heading level for navigation
  - `.h1`, `.h2`, `.h3`, `.h4`, `.h5`, `.h6`

**Example with Multiple Options:**
```swift
Button("Submit Form") {
    // action
}
.accessibility(options: [
    .traits([.isButton]),
    .labels("Submit Application Form"),
    .hint("Double tap to submit your application"),
    .behaviour(children: .ignore)
])
```

## 🎨 Customization

All components support extensive customization through parameters. Refer to individual component documentation for detailed customization options.

## 📋 Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

&copy; 2025 Israel Manzo. All rights reserved.
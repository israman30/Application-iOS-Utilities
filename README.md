# iOS Utilities

[![Build](https://github.com/israman30/Application-iOS-Utilities/actions/workflows/ci.yml/badge.svg)](https://github.com/israman30/Application-iOS-Utilities/actions/workflows/ci.yml)

A lightweight **SwiftUI utilities library** with reusable UI components and patterns you can drop into iOS apps—buttons, floating action button, toast notifications, validated text fields, ratings, settings-style controls (toggle/stepper/slider/pickers), and grid/layout helpers—plus previewable **sample views** and reference screens (accessibility checklist, navigation coordinator).

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
   `git clone https://github.com/israman30/Application-iOS-Utilities.git`

2. In Xcode, drag `Utils/Utils.xcodeproj` into your app project.
3. Select your app target → **General** → **Frameworks, Libraries, and Embedded Content**.
4. Add `Utils.framework` and choose the appropriate embed option for your app.

### Option B: Copy the source files (quickest way to use everything)

Copy the Swift files from `Utils/Utils/` into your app target (useful if you want to tweak styling, or if you hit access-control friction consuming it as a compiled framework).

## 🚀 Quick start

If you integrated the framework target, import the module where you use the components:
`import Utils`

Then use any component like you would in a normal SwiftUI view.

## 📚 Documentation (usage snippets + instructions)

All usage snippets have been moved out of this README into `Documentation/`.

- **Start here**: [`Documentation/README.md`](Documentation/README.md)

## 🖼️ Sample displays (previews)

Each component has a **sample display** you can run in Xcode previews.

- Open `Utils/Utils.xcodeproj`
- Open any file under `Utils/Utils/`
- Use the SwiftUI Canvas preview for the provided `*_Previews` / `*SampleView`

## 📦 Components (docs + sample links)

- **Buttons**: docs [`Documentation/Buttons.md`](Documentation/Buttons.md) · sample [`ButtonView` preview](Utils/Utils/ButtonView.swift#L11-L67)
- **Floating action button**: docs [`Documentation/FloatingButton.md`](Documentation/FloatingButton.md) · sample [`FloatingButtonView` preview](Utils/Utils/FloatingButtonView.swift#L11-L79)
- **Toast**: docs [`Documentation/Toast.md`](Documentation/Toast.md) · sample [`ToastViewSampleView` preview](Utils/Utils/ToastView.swift#L539-L838)
- **Text field**: docs [`Documentation/TextField.md`](Documentation/TextField.md) · sample [`TextFieldViewUtilSampleView` preview](Utils/Utils/TextFieldUtils.swift#L293-L384)
- **Ratings (stars)**: docs [`Documentation/RatingStars.md`](Documentation/RatingStars.md) · sample [`RatingStarsSampleView` preview](Utils/Utils/RatingStartsView.swift#L10-L133)
- **Ratings (hearts)**: docs [`Documentation/RatingHearts.md`](Documentation/RatingHearts.md) · sample [`RatingHeartsSampleView` preview](Utils/Utils/RatingHeartsView.swift#L10-L131)
- **Slider with controls**: docs [`Documentation/SliderControl.md`](Documentation/SliderControl.md) · sample [`SliderControlView` preview](Utils/Utils/SliderControlView.swift#L11-L55)
- **Stepper**: docs [`Documentation/Stepper.md`](Documentation/Stepper.md) · sample [`StepperView` preview](Utils/Utils/StepperView.swift#L10-L58)
- **Pickers**: docs [`Documentation/Picker.md`](Documentation/Picker.md) · sample [`PickerView` preview](Utils/Utils/PickerView.swift#L10-L70)
- **Toggle**: docs [`Documentation/Toggle.md`](Documentation/Toggle.md) · sample [`ToggleView` preview](Utils/Utils/ToggleView.swift#L13-L50)
- **Forms**: docs [`Documentation/Form.md`](Documentation/Form.md) · sample [`FormView` preview](Utils/Utils/FormView.swift#L13-L128)
- **Grids**: docs [`Documentation/Grid.md`](Documentation/Grid.md) · sample [`ScrollGridViewSampleView` preview](Utils/Utils/GridView.swift#L106-L211), [`GridViewSampleView` preview](Utils/Utils/SquareGridView.swift#L92-L168)
- **Like button**: docs [`Documentation/HeartLike.md`](Documentation/HeartLike.md) · sample [`HeartLikeSampleView` preview](Utils/Utils/HeartLikeView.swift#L10-L102)
- **Tooltip / activity pill**: docs [`Documentation/Tooltip.md`](Documentation/Tooltip.md) · sample [`TooltipView` preview](Utils/Utils/TooltipView.swift#L11-L75)
- **Accessibility utilities**: docs [`Documentation/Accessibility.md`](Documentation/Accessibility.md) · sample [`AccessibilityView` preview](Utils/Utils/AccessibilityView.swift#L13-L299)
- **Navigation coordinator**: docs [`Documentation/NavigationCoordinator.md`](Documentation/NavigationCoordinator.md) · sample [`ContentView` preview](Utils/Utils/NavigationCoordinator.swift#L407-L422)

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

MIT License. See [`LICENSE.md`](LICENSE.md).

---

&copy; 2026 Israel Manzo.
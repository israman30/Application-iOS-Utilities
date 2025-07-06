# Contributing to Application-iOS-Utilities

Thank you for your interest in contributing to Application-iOS-Utilities! This document provides guidelines and best practices for contributing to this SwiftUI utilities framework.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Branching Strategy](#branching-strategy)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Code Style Guidelines](#code-style-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Component Development Guidelines](#component-development-guidelines)

## 🚀 Getting Started

### Prerequisites

- Xcode 12.0 or later
- iOS 14.0+ deployment target
- Swift 5.3 or later
- Git

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Application-iOS-Utilities.git
   cd Application-iOS-Utilities
   ```
3. Add the original repository as upstream:
   ```bash
   git remote add upstream https://github.com/original-owner/Application-iOS-Utilities.git
   ```

## 🔧 Development Setup

1. Open `Utils.xcodeproj` in Xcode
2. Build the project to ensure everything compiles correctly
3. Run the tests to verify the current state
4. Create a new branch for your feature/fix

## 🌿 Branching Strategy

We follow a simplified Git Flow approach:

### Branch Types

- **`main`** - Production-ready code
- **`develop`** - Integration branch for features
- **`feature/*`** - New features and enhancements
- **`bugfix/*`** - Bug fixes
- **`hotfix/*`** - Critical production fixes
- **`release/*`** - Release preparation

### Branch Naming Convention

```
<type>/<description>
```

**Types:**
- `feature/` - New features
- `bugfix/` - Bug fixes
- `hotfix/` - Critical fixes
- `release/` - Release preparation
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Adding or updating tests

**Examples:**
```
feature/custom-button-styles
bugfix/toast-view-memory-leak
docs/update-readme-installation
refactor/accessibility-improvements
test/add-button-view-tests
```

### Creating a New Branch

```bash
# Update your local main branch
git checkout main
git pull upstream main

# Create and switch to a new feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b bugfix/your-bug-description
```

## 💬 Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **`feat`** - A new feature
- **`fix`** - A bug fix
- **`docs`** - Documentation only changes
- **`style`** - Changes that do not affect the meaning of the code
- **`refactor`** - A code change that neither fixes a bug nor adds a feature
- **`perf`** - A code change that improves performance
- **`test`** - Adding missing tests or correcting existing tests
- **`chore`** - Changes to the build process or auxiliary tools

### Scopes

- **`button`** - Button-related components
- **`form`** - Form-related components
- **`rating`** - Rating components
- **`accessibility`** - Accessibility features
- **`docs`** - Documentation
- **`ci`** - Continuous Integration
- **`build`** - Build system

### Examples

```bash
# Feature commit
feat(button): add gradient button style support

# Bug fix commit
fix(toast): resolve memory leak in ToastView

# Documentation commit
docs(readme): update installation instructions

# Refactor commit
refactor(accessibility): improve accessibility modifier implementation

# Test commit
test(button): add unit tests for ButtonViewUtils

# Breaking change
feat(button)!: change button style API to use enum

BREAKING CHANGE: ButtonViewUtils now requires ButtonStyle enum instead of string
```

### Commit Message Rules

1. **Use the imperative mood** ("add" not "added" or "adds")
2. **Don't capitalize the first letter**
3. **No dot (.) at the end**
4. **Keep the subject line under 50 characters**
5. **Use the body to explain what and why vs. how**

## 📝 Code Style Guidelines

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and [Google's Swift Style Guide](https://google.github.io/swift/).

#### Naming Conventions

```swift
// ✅ Good
struct ButtonViewUtils: View { }
enum ButtonStyleType { }
var isVisible: Bool = false

// ❌ Bad
struct buttonViewUtils: View { }
enum buttonStyleType { }
var visible: Bool = false
```

#### Component Structure

```swift
//
//  ComponentName.swift
//  Utils
//
//  Created by Your Name on Date.
//

import SwiftUI

// MARK: - Usage View (for previews)
struct ComponentName: View {
    var body: some View {
        // Preview implementation
    }
}

// MARK: - Public Component
public struct ComponentNameUtils: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void
    
    // MARK: - Initializer
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    // MARK: - Body
    public var body: some View {
        // Implementation
    }
}

// MARK: - Extensions
extension View {
    func componentModifier() -> some View {
        // Modifier implementation
    }
}

// MARK: - Preview
#Preview {
    ComponentName()
}
```

#### Documentation

```swift
/// A customizable button component with various styles and icons.
///
/// Use this component to create buttons with consistent styling across your app.
/// Supports both icon and text labels, with customizable colors and behaviors.
///
/// - Parameters:
///   - label: The text to display on the button
///   - icon: Optional SF Symbol name for the icon
///   - action: Closure to execute when the button is tapped
///
/// - Example:
/// ```swift
/// ButtonViewUtils(label: "Tap me", icon: "plus") {
///     print("Button tapped!")
/// }
/// ```
public struct ButtonViewUtils: View {
    // Implementation
}
```

### File Organization

```
Utils/
├── Utils/
│   ├── Components/
│   │   ├── ButtonView.swift
│   │   ├── ToastView.swift
│   │   └── ...
│   ├── Extensions/
│   │   └── View+Extensions.swift
│   ├── Utilities/
│   │   └── AccessibilityUtils.swift
│   └── Assets/
│       └── Images/
├── UtilsTests/
└── Utils.docc/
```

## 🔄 Pull Request Process

### Before Submitting a PR

1. **Ensure your code compiles** without warnings
2. **Run all tests** and ensure they pass
3. **Update documentation** if needed
4. **Add tests** for new functionality
5. **Follow the commit message guidelines**

### PR Template

```markdown
## Description
Brief description of the changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] I have tested this change locally
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] All existing tests pass

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

## Screenshots (if applicable)
Add screenshots to help explain your changes.

## Additional Notes
Any additional information or context.
```

### PR Review Process

1. **Automated Checks** - CI/CD pipeline runs tests and linting
2. **Code Review** - At least one maintainer must approve
3. **Documentation Review** - Ensure documentation is updated
4. **Merge** - Once approved, the PR will be merged

## 🐛 Issue Reporting

### Before Creating an Issue

1. Check if the issue has already been reported
2. Search the documentation for solutions
3. Try to reproduce the issue in a minimal example

### Issue Template

```markdown
## Bug Report

### Description
A clear and concise description of the bug.

### Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

### Expected Behavior
A clear and concise description of what you expected to happen.

### Actual Behavior
A clear and concise description of what actually happened.

### Environment
- iOS Version: [e.g., 15.0]
- Xcode Version: [e.g., 13.2]
- Utils Version: [e.g., 1.0.0]

### Additional Context
Add any other context about the problem here.

### Code Example
```swift
// Minimal code example that reproduces the issue
```

### Screenshots
If applicable, add screenshots to help explain your problem.
```

## 🧩 Component Development Guidelines

### Creating New Components

1. **Follow the naming convention**: `ComponentNameUtils`
2. **Make it public**: All components should be publicly accessible
3. **Add documentation**: Include comprehensive documentation
4. **Include previews**: Add SwiftUI previews for testing
5. **Add tests**: Create unit tests for the component
6. **Consider accessibility**: Ensure the component is accessible

### Component Checklist

- [ ] Component is publicly accessible
- [ ] Comprehensive documentation added
- [ ] SwiftUI preview included
- [ ] Unit tests written
- [ ] Accessibility features implemented
- [ ] Follows naming conventions
- [ ] No compiler warnings
- [ ] Performance considerations addressed

### Example Component Structure

```swift
//
//  NewComponent.swift
//  Utils
//
//  Created by Your Name on Date.
//

import SwiftUI

// MARK: - Usage View
struct NewComponent: View {
    var body: some View {
        NewComponentUtils(title: "Example") {
            print("Tapped!")
        }
    }
}

// MARK: - Public Component
public struct NewComponentUtils: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void
    
    // MARK: - Initializer
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    // MARK: - Body
    public var body: some View {
        Button(title, action: action)
            .accessibility(options: [
                .labels(title),
                .traits([.isButton])
            ])
    }
}

// MARK: - Preview
#Preview {
    NewComponent()
}
```

## 📚 Documentation Guidelines

### README Updates

- Update the main README.md when adding new components
- Include code examples for new features
- Update the components list
- Add any new installation requirements

### Code Documentation

- Use Swift documentation comments (`///`)
- Include parameter descriptions
- Provide usage examples
- Document any public APIs

## 🤝 Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Follow the project's coding standards

### Communication

- Use clear and concise language
- Provide context for suggestions
- Be open to feedback and discussion
- Respect different perspectives and approaches

## 📞 Getting Help

If you need help with contributing:

1. **Check the documentation** first
2. **Search existing issues** for similar problems
3. **Create a new issue** if needed
4. **Join our community** discussions

## 🎉 Recognition

Contributors will be recognized in:
- The project's README.md
- Release notes
- GitHub contributors page

Thank you for contributing to Application-iOS-Utilities! 🚀 
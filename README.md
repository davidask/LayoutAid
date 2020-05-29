![Tests](https://github.com/davidask/LayoutAid/workflows/Tests/badge.svg)

# LayoutAid
AutoLayout extensions for iOS, macOS, and tvOS.

## Features

- [x] Declarative DSL for creating layout constraints
- [x] `keyboardLayoutGuide` for `UIView` on iOS, fully animatable
- [x] `keyboardSafeAreaLayoutGuide` for `UIView` on iOS, fully animatable
- [x] Extensions for `UIScrollView` adjusting `contentInset` based on keyboard appearance

## Requirements

- iOS 11+
- tvOS 11+
- macOS 10.11+

## Installation

### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/LayoutAid.framework` to an iOS project.

```
github "davidask/LayoutAid"
```

### Swift Package Manager
This project has support for Swift Package Manager.

## Usage

To use the extensions provided in this library, you must `import LayoutAid`.

### Layout DSL

```swift
NSLayoutConstraint.activate {
    containerView.constrain(
        Edges(equalTo: view.layoutMarginsGuide)
    )

    iconView.constrain {
        Size(equalTo: CGSize(width: 50, height: 50))
        Center(equalTo: containerView)
    }

    label.constrain {
        Top(equalToSystemSpacingBelow: iconView)
        CenterX(equalTo: containerView.readableContentGuide)
        Width(lessThanOrEqualTo: containerView.readableContentGuide, multiplier: 0.75)
    }
}
```

Constraints are best activated in bulk, however, creating complex layouts can get verbose, even with layout anchors.
This library provides two static methods on `NSLayoutConstraint` using function builders:

- `build`, for creating constraints
- `activate`, for creating and activating constraints

To constrain a view or layout guide use `view.anchor` or `layoutGuide.anchor`. Constrain blocks can be used inside `NSLayoutConstraint.build` or `NSLayoutConstraint.activate`.

This library aligns its semantics with Apples layout anchor API, meaning that you'll find a constraint builder for each anchor type, including convenience builders.

* `Leading`
* `Trailing`
* `Left`
* `Right`
* `Top`
* `Bottom`
* `CenterX`
* `CenterY`
* `Center`
* `Edges`
* `DirectionalEdges`
* `Size`
* `AspectRatio`

### Keyboard layout guides

Keyboard management in iOS can be tricky. This library provides a lazy accessor to `keyboardLayoutGuide` and `keyboardSafeAreaLayoutGuide`. Backed by a `Keyboard` type observing the keyboard state this allows you to easily layout your views with the keyboard in mind.

```swift
NSLayoutConstraint.activate {
    keyboardBackgroundView.constrain(
        Edges(equalTo: view.keyboardLayoutGuide)
    )

    keyboardAvoidingView.constrain {
        Leading(equalTo: view)
        Trailing(equalTo: view)
        Top(equalTo: view.safeAreaLayoutGuide)
        Bottom(lessThanOrEqualTo: view.keyboardSafeAreaLayoutGuide)
    }
}
```

### UIScrollView extensions

This library can automatically adjust `contentInset` of `UIScrollView` using
- `UIScrollView.adjustContentInsetForKeyboard()`, to immediately adjust scroll view insets to keyboard
- `UIScrollView.beginAdjustingContentInsetForKeyboard()`, to start observing keyboard adjusting scroll view insets automatically
- `UIScrollView.endAdjustingContentInsetForKeyboard()`, to stop observing keyboard adjusting scroll view insets automatically

## Contribute
Please feel welcome contributing to **LayoutAid**, check the ``LICENSE`` file for more info.

## Credits

David Ask
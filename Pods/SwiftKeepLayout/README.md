# SwiftKeepLayout

This pod offers some handy attributes to [KeepLayout](https://github.com/Tricertops/KeepLayout) for Swift (see the [swift-legacy](https://github.com/Tricertops/KeepLayout/tree/swift-legacy) branch) to make it easier to use.

[![Version](https://img.shields.io/cocoapods/v/SwiftKeepLayout.svg?style=flat)](http://cocoapods.org/pods/SwiftKeepLayout)
[![License](https://img.shields.io/cocoapods/l/SwiftKeepLayout.svg?style=flat)](http://cocoapods.org/pods/SwiftKeepLayout)
[![Platform](https://img.shields.io/cocoapods/p/SwiftKeepLayout.svg?style=flat)](http://cocoapods.org/pods/SwiftKeepLayout)

## Installation

SwiftKeepLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftKeepLayout"
```

## Usage

Once installed, you can fully use KeepLayout + SwiftKeepLayout by doing, SwiftKeepLayout already include KeepLayout:

```swift
import SwiftKeepLayout
```

Then you can do stuff like:
```swift
// With KeepLayout
myView.keepTopInset.equal = KeepValueMake(CGFloat(30), Float(600))
// With SwiftKeepLayout
myView.keepTopInset.vEqual = (30, 600)

// With KeepLayout
myView.keepTopInset.required = 40.0
// With SwiftKeepLayout
myView.keepTopInset.vEqual = 40.0

// With KeepLayout
myView.keepTopInset.min = KeepHigh(20.0)
// With SwiftKeepLayout
myView.keepTopInset.vMin = (20.0, KeepPriorityHigh)
```

## Author

Tancrède Chazallet, please use GitHub issue system if you wish to contact me about this repository.

## License

SwiftKeepLayout is available under the MIT license. See the LICENSE file for more info.

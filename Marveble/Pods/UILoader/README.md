# UILoader

[![CI Status](http://img.shields.io/travis/Bell App Lab/UILoader.svg?style=flat)](https://travis-ci.org/Bell App Lab/UILoader)
[![Version](https://img.shields.io/cocoapods/v/UILoader.svg?style=flat)](http://cocoapods.org/pods/UILoader)
[![License](https://img.shields.io/cocoapods/l/UILoader.svg?style=flat)](http://cocoapods.org/pods/UILoader)
[![Platform](https://img.shields.io/cocoapods/p/UILoader.svg?style=flat)](http://cocoapods.org/pods/UILoader)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0+

## Installation

### CocoaPods

UILoader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UILoader"
```

### Git Submodules

**Why submodules, you ask?**

Following [this thread](http://stackoverflow.com/questions/31080284/adding-several-pods-increases-ios-app-launch-time-by-10-seconds#31573908) and other similar to it, and given that Cocoapods only works with Swift by adding the use_frameworks! directive, there's a strong case for not bloating the app up with too many frameworks. Although git submodules are a bit trickier to work with, the burden of adding dependencies should weigh on the developer, not on the user. :wink:

To install UILoader using git submodules:

```
cd toYourProjectsFolder
git submodule add -b Submodule --name UILoader https://github.com/BellAppLab/UILoader.git
```

Navigate to the new UILoader folder and drag the Pods folder to your Xcode project.

## Author

Bell App Lab, apps@bellapplab.com

## License

UILoader is available under the MIT license. See the LICENSE file for more info.

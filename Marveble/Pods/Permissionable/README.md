# Permissionable

[![CI Status](http://img.shields.io/travis/Bell App Lab/Permissionable.svg?style=flat)](https://travis-ci.org/Bell App Lab/Permissionable)
[![Version](https://img.shields.io/cocoapods/v/Permissionable.svg?style=flat)](http://cocoapods.org/pods/Permissionable)
[![License](https://img.shields.io/cocoapods/l/Permissionable.svg?style=flat)](http://cocoapods.org/pods/Permissionable)
[![Platform](https://img.shields.io/cocoapods/p/Permissionable.svg?style=flat)](http://cocoapods.org/pods/Permissionable)

## Usage

```swift
import Permissionable

class ViewController: UIViewController {
    func askPermission() {
        Permissions.Camera.request(self) { (success: Bool) -> Void in 
            if success {
                print("\o/")
            }
        }
    }
    func askForPushPermission() {
        Permissions.Push.request(self, categories) { (success: Bool) -> Void in 
            if success {
                print("\o/")
            }
        }
    }
}
    
//===================================================
    
import Permissionable

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    {...}

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Permissions.didFinishRegisteringForPushNotifications(error)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //Do domething with the token
        Permissions.didFinishRegisteringForPushNotifications(nil)
    }
}

//===================================================

import Permissionable

class UserHandler {
    func logout() {
        Permissions.reset()
    }
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Localization

To localize this library, make sure you include the following entries in your Localizable.strings file:

`"Yes" = "<Your translation>";`

`"No" = "<Your translation>";`

`"Please" = "<Your translation>"; //Default alert title`

`"Would you mind if we send you push notifications?" = "<Your translation>"; //Default message for push notifications`

`"Would you mind if we access your camera?" = "<Your translation>"; //Default message for the device's camera`

`"Would you mind if we access your photos?" = "<Your translation>"; //Default message for the user's photos`

`"Uh oh" = "<Your translation>"; //Default alert title for when things go wrong`

`"Looks like we can't access the camera... Would you like to go to the Settings app to check?" = "<Your translation>"; //Default message to prompt the user to fix a permission on the Settings app`

`"Looks like we can't access your photos... Would you like to go to the Settings app to check?" = "<Your translation>"; //Default message to prompt the user to fix a permission on the Settings app`


## Requirements

iOS 8+

## Installation

Permissionable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Permissionable"
```

**Please note** that this will install all possible permissions (and their related libraries as well), bloating up your app's dependencies. Take a look at the commands below to find one that suits your needs:

```ruby
pod "Permissionable/Camera"
```

```ruby
pod "Permissionable/Photos"
```

## Author

Bell App Lab, apps@bellapplab.com

## License

Permissionable is available under the MIT license. See the LICENSE file for more info.

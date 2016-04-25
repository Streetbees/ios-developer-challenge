import UIKit
import Defines
import Alertable


//MARK: - Main
/*
    An simplified way of asking permissions to the user on iOS.
*/
public struct Permissions
{
    //MARK: Consts
    public static func domain() -> String
    {
        return "com.bellapplab.Permissionable"
    }
    
    internal static func defaultsDomain() -> String
    {
        return self.domain() + "." + Defines.App.Name
    }
    
    /*
        Resets any cached information on permissions requested to the user.
    
        @discussion Permissionable may cache information whether we have requested some permissions or not. Calling this method clears those caches.
    */
    public static func reset()
    {
        NSUserDefaults.setPushRegistration(nil)
    }
    
    /*
        When you ask for permissions, this is how you get a response back.
    */
    public typealias Result = (success: Bool) -> Void
    
    /*
        Types
        
        For now we're supporting Camera and Photos permissions. More to come!
    */
    public class Camera: Permissionable
    {
        public static func request(sender: UIViewController, _ block: Result?)
        {
            Permissions.request(Camera(), sender, nil, block)
        }
        
        public static func showError(sender: UIViewController, _ block: Permissions.Result?)
        {
            Permissions.showError(Camera(), sender: sender, block)
        }
    }
    public class Photos: Permissionable
    {
        public static func request(sender: UIViewController, _ block: Result?)
        {
            Permissions.request(Photos(), sender, nil, block)
        }
        
        public static func showError(sender: UIViewController, _ block: Permissions.Result?)
        {
            Permissions.showError(Photos(), sender: sender, block)
        }
    }
    public class Location: Permissionable
    {
        public enum Kind {
            case WhenInUse, Always
        }
        
        public static func request(sender: UIViewController, kind: Kind, _ block: Result?)
        {
            Permissions.request(Location(kind), sender, nil, block)
        }
        
        internal let kind: Kind
        private init(_ kind: Kind) {
            self.kind = kind
        }
        internal convenience init() {
            self.init(.WhenInUse)
        }
        
        public static func showError(sender: UIViewController, _ block: Permissions.Result?)
        {
            Permissions.showError(Location(), sender: sender, block)
        }
    }
    
    public class Push: Permissionable
    {
        public static var isThere: Bool {
            if let result = Push().hasAccess() {
                return result.boolValue
            }
            return false
        }
        
        public static var hasAsked: Bool {
            return Push().hasAccess() != nil
        }
        
        @objc func hasAccess() -> NSNumber? {
            return NSUserDefaults.isRegisteredForPush()
        }
        
        public static func request(sender: UIViewController, _ categories: Set<UIUserNotificationCategory>?, _ block: Result? = nil)
        {
            Permissions.request(Push(categories), sender, categories, block)
        }
        
        private let categories: Set<UIUserNotificationCategory>?
        private init(_ categories: Set<UIUserNotificationCategory>?) {
            self.categories = categories
        }
        private convenience init() {
            self.init(nil)
        }
        
        private func proceed(block: Result?)
        {
            pushBlock = block
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: self.categories)
            let application = UIApplication.sharedApplication()
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        @objc func makeAction(sender: UIViewController, _ block: Permissions.Result?) -> AnyObject {
            return Alert.Action(title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
                Alert.on = true
                block?(success: true)
            })
        }
    }
    
    //MARK: Aux
    private static func request(permission: Permissionable, _ sender: UIViewController, _ categories: Set<UIUserNotificationCategory>?, _ block: Result? = nil)
    {
        if let access = permission.hasAccess?() { //We either have access or we've been denied
            if access.boolValue { //No need to ask the user
                if let push = permission as? Push {
                    //But in the case of push notifications, we still want to get a token fresh from the oven
                    push.proceed(block)
                    return
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    block?(success: true)
                }
                return
            }
            //We've been denied access
            self.showError(permission, sender: sender, block)
            return
        }
        //We haven't asked for permissions yet
        Alert.show(permission.message, permission.title, sender, self.actions(permission, sender, block))
    }
    
    private static func actions(permission: Permissionable, _ sender: UIViewController, _ block: Result?) -> [Alert.Action]
    {
        var result: [Alert.Action] = []
        result.append(Alert.Action(title: NSLocalizedString("No", comment: ""), style: .Destructive, handler: block == nil ? nil : { (UIAlertAction) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                block!(success: false)
            }
        }))
        
        switch permission
        {
        case is Camera:
            if let action = permission.makeAction?(sender, block) as? Alert.Action {
                result.append(action)
            }
            break
        case is Photos, is Location:
            let block = { (success: Bool) ->  Void in
                if !success {
                    if let privatePermission = PrivatePermission.privateFor(publicPermission: permission) {
                        Alert.show(privatePermission.message, privatePermission.title, sender, privatePermission.actions(block))
                        return
                    }
                }
                block?(success: true)
            }
            if let action = permission.makeAction?(sender, block) as? Alert.Action {
                result.append(action)
            }
            break
        case is Push:
            let pushBlock = { (success: Bool) ->  Void in
                (permission as! Push).proceed(block)
            }
            if let action = permission.makeAction?(sender, pushBlock) as? Alert.Action {
                result.append(action)
            }
            break
        default: break
        }
        
        return result
    }
    
    private static func showError(permission: Permissionable, sender: UIViewController, _ block: Permissions.Result?)
    {
        if let privatePermission = PrivatePermission.privateFor(publicPermission: permission) {
            Alert.show(privatePermission.message, privatePermission.title, sender, privatePermission.actions(block))
        }
    }
    
    //MARK: Push
    public static func didFinishRegisteringForPushNotifications(error: NSError?)
    {
        func finish(result: Bool) {
            NSUserDefaults.setPushRegistration(NSNumber(bool: result))
            returnFromPush(result)
        }
        
        if let finalError = error {
#if DEGUB
            if finalError.code == 3010 {
                print("Push notifications are not supported in the iOS Simulator.")
            }
            print("Permissionable says: Something went wrong with Push Notifications... -> \(finalError)")
#endif
            finish(false)
            return
        }
        
        finish(true)
    }
}


//MARK: - Internal
@objc internal protocol Permissionable
{
    optional func hasAccess() -> NSNumber?
    optional func makeAction(sender: UIViewController, _ block: Permissions.Result?) -> AnyObject
}

private extension Permissionable
{
    /*
    These titles are presented when we're trying to get the user's permission.
    
    We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var title: String {
        switch self
        {
        case is Permissions.Camera, is Permissions.Photos, is Permissions.Push, is Permissions.Location: return NSLocalizedString("Please", comment: "Title for the alert that appears when we want to ask the user for permissions")
        default: return ""
        }
    }
    
    /*
    These messages are presented when we're trying to get the user's permission.
    
    We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var message: String {
        switch self
        {
        case is Permissions.Camera: return NSLocalizedString("Would you mind if we access your camera?", comment: "Message that asks the user for the camera")
        case is Permissions.Photos: return NSLocalizedString("Would you mind if we access your photos?", comment: "Message that asks the user for their photos")
        case is Permissions.Push: return NSLocalizedString("Would you mind if we send you push notifications?", comment: "Message that asks the user if we can send them push notifications")
        case is Permissions.Location: return NSLocalizedString("Would you mind if we access your location?", comment: "Message that asks the user if we can access their location")
        default: return ""
        }
    }
}

internal enum PrivatePermission
{
    static func privateFor(publicPermission permission: Permissionable) -> PrivatePermission?
    {
        switch permission
        {
        case is Permissions.Camera: return .NoCamera
        case is Permissions.Photos: return .NoPhotos
        case is Permissions.Location: return .NoLocation
        default: return nil
        }
    }
    
    case NoCamera, NoPhotos, NoLocation
    
    /*
    These titles are presented when we're trying to get the user's permission.
    
    We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var title: String {
        switch self
        {
        case .NoCamera, .NoPhotos, .NoLocation: return NSLocalizedString("Uh oh", comment: "Title for the alert that appears when something went wrong")
        }
    }
    
    /*
        These messages are presented when there's an error in getting the user's permission. Maybe they have denied it to the app, maybe there are parental controls in place. 
    
        In such cases, we ask the user if they want to go to the device's settings and check them.
    
        We do not provide any translations for these messages, so if your app would like to translate them (or if you would like to have a different wording), simply add keys to your Localizable.strings files that match the ones below.
    */
    var message: String {
        switch self
        {
        case .NoCamera: return NSLocalizedString("Looks like we can't access the camera... Would you like to go to the Settings app to check?", comment: "Message that appears when we're having trouble accessing the camera")
        case .NoPhotos: return NSLocalizedString("Looks like we can't access your photos... Would you like to go to the Settings app to check?", comment: "Message that appears when we're having trouble accessing the user's photos")
        case .NoLocation: return NSLocalizedString("Looks like we can't access your location... Would you like to go to the Settings app to check?", comment: "Message that appears when we're having trouble accessing the user's location")
        }
    }
    
    func actions(block: Permissions.Result?) -> [Alert.Action]
    {
        var result: [Alert.Action] = []
        result.append(Alert.Action(title: NSLocalizedString("No", comment: ""), style: .Destructive, handler: block == nil ? nil : { (UIAlertAction) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                block!(success: false)
            }
        }))
        result.append(Alert.Action(title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                block?(success: false)
            }
        }))
        return result
    }
}

private var pushBlock: Permissions.Result? = nil

private func returnFromPush(result: Bool)
{
    if let block = pushBlock {
        Alert.on = false
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            block(success: result)
        }
    }
    pushBlock = nil
}

private extension NSUserDefaults
{
    //Push
    class var pushKey: String {
        return Permissions.defaultsDomain() + ".PushKey"
    }
    
    class func isRegisteredForPush() -> NSNumber?
    {
        return NSUserDefaults.standardUserDefaults().objectForKey(self.pushKey) as? NSNumber
    }
    
    class func setPushRegistration(registered: NSNumber?)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(registered, forKey: self.pushKey)
        defaults.synchronize()
    }
}

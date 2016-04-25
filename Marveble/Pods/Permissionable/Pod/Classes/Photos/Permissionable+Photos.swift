import Photos
import Alertable


extension Permissions.Photos
{
    public static var isThere: Bool {
        if let result = Permissions.Photos().hasAccess() {
            return result.boolValue
        }
        return false
    }
    
    public static var hasAsked: Bool {
        return Permissions.Photos().hasAccess() != nil
    }
    
    @objc func hasAccess() -> NSNumber? {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status
        {
        case .Authorized: return NSNumber(bool: true)
        case .Denied, .Restricted: return NSNumber(bool: false)
        case .NotDetermined: return nil
        }
    }
    
    @objc func makeAction(sender: UIViewController, _ block: Permissions.Result?) -> AnyObject {
        return Alert.Action(title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
            Alert.on = true
            PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) -> Void in
                Alert.on = false
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    block?(success: status == .Authorized)
                }
            }
        })
    }
}

import AVFoundation
import Alertable


extension Permissions.Camera
{
    public static var isThere: Bool {
        if let result = Permissions.Camera().hasAccess() {
            return result.boolValue
        }
        return false
    }
    
    public static var hasAsked: Bool {
        return Permissions.Camera().hasAccess() != nil
    }
    
    @objc func hasAccess() -> NSNumber? {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
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
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (success: Bool) -> Void in
                Alert.on = false
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    block?(success: success)
                }
            })
        })
    }
}

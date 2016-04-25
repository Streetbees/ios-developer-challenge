import CoreLocation
import Alertable


extension Permissions.Location
{
    public static var isThere: Bool {
        if let result = Permissions.Location().hasAccess() {
            return result.boolValue
        }
        return false
    }
    
    public static var hasAsked: Bool {
        return Permissions.Location().hasAccess() != nil
    }
    
    @objc func hasAccess() -> NSNumber? {
        let status = CLLocationManager.authorizationStatus()
        switch status
        {
        case .AuthorizedWhenInUse, .AuthorizedAlways: return NSNumber(bool: true)
        case .Denied, .Restricted: return NSNumber(bool: false)
        case .NotDetermined: return nil
        }
    }
    
    @objc func makeAction(sender: UIViewController, _ block: Permissions.Result?) -> AnyObject {
        return Alert.Action(title: NSLocalizedString("Yes", comment: ""), style: .Default, handler: { (UIAlertAction) -> Void in
            Alert.on = true
            LocationRequester.request(self.kind) { (status) in
                Alert.on = false
                block?(success: status == .AuthorizedWhenInUse || status == .AuthorizedAlways)
            }
        })
    }
}


internal class LocationRequester: NSObject, CLLocationManagerDelegate
{
    private lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    @nonobjc private static var singleton: LocationRequester?
    
    private typealias LocationRequesterBlock = (status: CLAuthorizationStatus) -> Void
    
    private var completionBlock: LocationRequesterBlock!
    
    @objc func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        let block = self.completionBlock
        dispatch_async(dispatch_get_main_queue()) { 
            block(status: status)
        }
        LocationRequester.singleton = nil
    }
    
    internal static func request(kind: Permissions.Location.Kind, _ block: (status: CLAuthorizationStatus) -> Void) {
        LocationRequester.singleton = LocationRequester()
        LocationRequester.singleton?.completionBlock = block
        switch kind {
        case .Always:
            LocationRequester.singleton?.locationManager.requestAlwaysAuthorization()
        case .WhenInUse:
            LocationRequester.singleton?.locationManager.requestWhenInUseAuthorization()
        }
    }
}

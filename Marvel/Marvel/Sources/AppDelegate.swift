import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let comicsViewController = ComicsViewController(nibName: .None, bundle: .None)
        let navController = UINavigationController(rootViewController: comicsViewController)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.whiteColor()
        
        setupDropbox()
                
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if let authResult = Dropbox.handleRedirectURL(url) {
            switch authResult {
            case .Success:
                print("Success! User is logged into Dropbox.")
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.dropboxLinkNotification, object: .None, userInfo: [Notification.dropboxLinkSuccessKey : true])
            case .Error(_, let description):
                print("Error: \(description)")
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.dropboxLinkNotification, object: .None, userInfo: [Notification.dropboxLinkSuccessKey : false])
            }
        }
        
        return false
    }
    
    func setupDropbox() {
        let appKey = "7mzmkj2ac4hyodx"
        Dropbox.setupWithAppKey(appKey)
    }
}

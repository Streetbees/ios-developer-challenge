import UIKit

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
        if DBSession.sharedSession().handleOpenURL(url) {
            if DBSession.sharedSession().isLinked() {
                return true
            }
        }
        
        return false
    }
    
    func setupDropbox() {
        let appKey = "7mzmkj2ac4hyodx"
        let appSecret = "9xwxfttz6m4dhgg"
        
        let dropboxSession = DBSession(appKey: appKey, appSecret: appSecret, root: kDBRootAppFolder)
        DBSession.setSharedSession(dropboxSession)
    }

}

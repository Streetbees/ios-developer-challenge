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
        
        return true
    }

}

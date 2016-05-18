import Foundation
import UIKit

public extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard
    }
    
    class func initialStoryboard() -> UIStoryboard {
        let initialStoryboard = UIStoryboard(name: "Initial", bundle: nil)
        return initialStoryboard
    }
    
    class func updatesStoryboard() -> UIStoryboard {
        let updatesStoryboard = UIStoryboard(name: "Updates", bundle: nil)
        return updatesStoryboard
    }
    
    class func discoverStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Discover", bundle: nil)
        return storyboard
    }
    
    class func profileStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard
    }
    
    class func notificationsStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        return storyboard
    }
    
    class func loginStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        return storyboard
    }
}
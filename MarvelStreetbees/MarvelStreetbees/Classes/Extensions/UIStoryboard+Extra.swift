import Foundation
import UIKit

public extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard
    }
}
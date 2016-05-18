import UIKit

public extension UIViewController {
    class func instantiate(storyboard storyboard:UIStoryboard) -> UIViewController? {
        let vc = storyboard.instantiateViewControllerWithIdentifier(self.nameOfClass)
        return vc
    }
}
import Foundation
import UIKit

public extension UINavigationBar {
    func hideBottomHairLine() {
        if let navBarHairlineImageView : UIImageView = self.findHairLineImageViewUnder(self) {
            navBarHairlineImageView.hidden = true;
        }
    }
    
    func showBottomHariline() {
        let navBarHairlineImageView : UIImageView = self.findHairLineImageViewUnder(self)!
        navBarHairlineImageView.hidden = false;
    }
    
    func findHairLineImageViewUnder(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairLineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}
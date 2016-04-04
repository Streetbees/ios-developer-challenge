import Foundation

extension UIButton {
    
    class func circularButton(target: AnyObject?, action: Selector, icon: UIImage) -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.grayColor()        
        b.setImage(icon, forState: .Normal)
        b.clipsToBounds = true
        b.layer.cornerRadius = 25
        b.layer.borderColor = UIColor.whiteColor().CGColor
        b.layer.borderWidth = 2
        b.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        return b
    }
}

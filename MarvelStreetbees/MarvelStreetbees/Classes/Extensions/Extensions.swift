import UIKit
import ObjectiveC
import MessageUI
import HexColors
//import CommonCrypto

// ============================================================================
// MARK: Basic Data types
// ============================================================================
extension Bool {
    mutating func toggle() {
        self = !self
    }
}

// ============================================================================
// MARK: UIFontDescriptor
// ============================================================================
extension UIFontDescriptor {

    class func prefferedFont(fontName fontName: String, dynamicTextStyle: String) -> UIFontDescriptor {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var fontSizeTable : NSDictionary = NSDictionary()
        }
        
        dispatch_once(&Static.onceToken) {
            Static.fontSizeTable = [
                UIFontTextStyleHeadline: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 26,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 25,
                    UIContentSizeCategoryAccessibilityExtraLarge: 24,
                    UIContentSizeCategoryAccessibilityLarge: 24,
                    UIContentSizeCategoryAccessibilityMedium: 23,
                    UIContentSizeCategoryExtraExtraExtraLarge: 23,
                    UIContentSizeCategoryExtraExtraLarge: 22,
                    UIContentSizeCategoryExtraLarge: 21,
                    UIContentSizeCategoryLarge: 20,
                    UIContentSizeCategoryMedium: 19,
                    UIContentSizeCategorySmall: 18,
                    UIContentSizeCategoryExtraSmall: 17
                ],
                UIFontTextStyleSubheadline: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 24,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 23,
                    UIContentSizeCategoryAccessibilityExtraLarge: 22,
                    UIContentSizeCategoryAccessibilityLarge: 22,
                    UIContentSizeCategoryAccessibilityMedium: 21,
                    UIContentSizeCategoryExtraExtraExtraLarge: 21,
                    UIContentSizeCategoryExtraExtraLarge: 20,
                    UIContentSizeCategoryExtraLarge: 19,
                    UIContentSizeCategoryLarge: 18,
                    UIContentSizeCategoryMedium: 17,
                    UIContentSizeCategorySmall: 16,
                    UIContentSizeCategoryExtraSmall: 15
                ],
                UIFontTextStyleBody: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 21,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 20,
                    UIContentSizeCategoryAccessibilityExtraLarge: 19,
                    UIContentSizeCategoryAccessibilityLarge: 19,
                    UIContentSizeCategoryAccessibilityMedium: 18,
                    UIContentSizeCategoryExtraExtraExtraLarge: 18,
                    UIContentSizeCategoryExtraExtraLarge: 17,
                    UIContentSizeCategoryExtraLarge: 16,
                    UIContentSizeCategoryLarge: 15,
                    UIContentSizeCategoryMedium: 14,
                    UIContentSizeCategorySmall: 13,
                    UIContentSizeCategoryExtraSmall: 12
                ],
                UIFontTextStyleCaption1: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 19,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 18,
                    UIContentSizeCategoryAccessibilityExtraLarge: 17,
                    UIContentSizeCategoryAccessibilityLarge: 17,
                    UIContentSizeCategoryAccessibilityMedium: 16,
                    UIContentSizeCategoryExtraExtraExtraLarge: 16,
                    UIContentSizeCategoryExtraExtraLarge: 16,
                    UIContentSizeCategoryExtraLarge: 15,
                    UIContentSizeCategoryLarge: 14,
                    UIContentSizeCategoryMedium: 13,
                    UIContentSizeCategorySmall: 12,
                    UIContentSizeCategoryExtraSmall: 12
                ],
                UIFontTextStyleCaption2: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 18,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 17,
                    UIContentSizeCategoryAccessibilityExtraLarge: 16,
                    UIContentSizeCategoryAccessibilityLarge: 16,
                    UIContentSizeCategoryAccessibilityMedium: 15,
                    UIContentSizeCategoryExtraExtraExtraLarge: 15,
                    UIContentSizeCategoryExtraExtraLarge: 14,
                    UIContentSizeCategoryExtraLarge: 14,
                    UIContentSizeCategoryLarge: 13,
                    UIContentSizeCategoryMedium: 12,
                    UIContentSizeCategorySmall: 12,
                    UIContentSizeCategoryExtraSmall: 11
                ],
                UIFontTextStyleFootnote: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 16,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 15,
                    UIContentSizeCategoryAccessibilityExtraLarge: 14,
                    UIContentSizeCategoryAccessibilityLarge: 14,
                    UIContentSizeCategoryAccessibilityMedium: 13,
                    UIContentSizeCategoryExtraExtraExtraLarge: 13,
                    UIContentSizeCategoryExtraExtraLarge: 12,
                    UIContentSizeCategoryExtraLarge: 12,
                    UIContentSizeCategoryLarge: 11,
                    UIContentSizeCategoryMedium: 11,
                    UIContentSizeCategorySmall: 10,
                    UIContentSizeCategoryExtraSmall: 10
                ],
            ]
        }
        
        let contentSize = UIApplication.sharedApplication().preferredContentSizeCategory
        
        let style = Static.fontSizeTable[dynamicTextStyle] as! NSDictionary
        
        return UIFontDescriptor(name: fontName, size: CGFloat((style[contentSize] as! NSNumber).floatValue))
    }
    
}

extension UIFont {
    
    class func listAllAvailableFonts() {
    
        for family in UIFont.familyNames()
        {
            print("\(family)")
            for names in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
        
    }

}

// ============================================================================
// MARK: Array
// ============================================================================
extension Array {
    func recursiveFlatMap<TResult>(transform: (Element) -> TResult?, children: (Element) -> [Element]) -> [TResult] {
        var result = [TResult]()
        for element in self {
            if let transformed = transform(element) {
                result.append(transformed)
            }
            result += children(element).recursiveFlatMap(transform, children: children)
        }
        return result
    }
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}


// ============================================================================
// MARK: String
// ============================================================================
extension String {
    func md5() -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func sizeOfString(constrainedToWidth width: CGFloat?, height: CGFloat?, font: UIFont) -> CGSize {
        
        var constraintRect = CGSize(width: CGFloat.max, height: CGFloat.max)
        if let width = width {
            constraintRect.width = width
        }
        if let height = height {
            constraintRect.height = height
        }
        
        return NSString(string: self)
            .boundingRectWithSize(constraintRect,
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: font],
                context: nil).size
    }
    
    func widthOfString(font: UIFont) -> CGFloat {
        return self.sizeOfString(constrainedToWidth: UIScreen.mainScreen().bounds.size.width, height: 100, font: font).width
    }
    
    // return calculated maximum font size that fits a box
    func calculateMaximumFontSize(box box: CGSize, boxPercent: CGFloat, fontName: String) -> CGFloat {
        
        // start values
        var fontSize : CGFloat = 7
        var boundingSize = CGSizeMake(0, 0)
        let restrictedBox = CGSizeMake(box.width * boxPercent, box.height * boxPercent)
        
        // if we have a valid string
        guard self.characters.count > 0 else {
            return fontSize
        }
        
        // check whether the font exists, else return minimum size
        guard let _ = UIFont(name: fontName, size: fontSize) else {
            return fontSize
        }
        
        while restrictedBox.height > boundingSize.height  &&
            restrictedBox.width > boundingSize.width  {
                
                fontSize++
                let textFontSize = fontSize + 1
                
                let font = UIFont(name: fontName, size: textFontSize)!
                
                let attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.blackColor()]
                
                boundingSize = NSAttributedString(string: self, attributes: attributes).boundingRectWithSize(restrictedBox, options: NSStringDrawingOptions.UsesFontLeading, context: nil).size
        }
        
        return fontSize
    }
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
}

// ============================================================================
// MARK: UIColor
// ============================================================================
extension UIColor {
    
    func darkerColorForColor(factor: CGFloat) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(
                red: max(r - factor, 0.0),
                green: max(g - factor, 0.0),
                blue: max(b - factor, 0.0),
                alpha: a)
        }
        
        return UIColor()
    }
    
    func lighterColorForColor(factor: CGFloat) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(
                red: min(r + factor, 1.0),
                green: min(g + factor, 1.0),
                blue: min(b + factor, 1.0),
                alpha: a)
        }
        
        return UIColor()
    }
    
    // let red = UIColor(rgba: "#ff0000")
    convenience init?(rgba: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        let alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#")
        {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue)
            {
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                blue  = CGFloat(hexValue & 0x0000FF) / 255.0
            }
            else
            {
                print("scan hex error, your string should be a hex string of 7 chars. ie: #ebb100")
                return nil
            }
        }
        else
        {
            print("invalid rgb string, missing '#' as prefix")
            return nil
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func adjustValue(color: UIColor, percentage: CGFloat = 1.5) -> UIColor
    {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return UIColor(hue: h, saturation: s, brightness: (b * percentage), alpha: a)
    }
    
    class func randomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    convenience init(hexString: String) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substringToIndex(2)
            let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
            let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)
            
            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
        
        
    }
    
    class func mainGreenColor() -> UIColor {
        return UIColor(hexString: "029B4E")!
    }
}

// ============================================================================
// MARK: UIBezierPath
// ============================================================================
func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
    return CGPointMake(radius * cos(angle) + offset.x, radius * sin(angle) + offset.y)
}

extension UIBezierPath {
    
    class func generateStar(size: CGSize = CGSizeMake(128, 128), pointsOnStar: Int = 5) -> UIBezierPath {
        let path = UIBezierPath()
        
        guard pointsOnStar > 3 else {
            return path
        }
        
        let starExtrusion : CGFloat = 30.0
        
        let center = CGPointMake(size.width / 2.0, size.height / 2.0)
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(pointsOnStar))
        let radius = size.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                path.moveToPoint(point)
            }
            
            path.addLineToPoint(midPoint)
            path.addLineToPoint(nextPoint)
            
            angle += angleIncrement
        }
        
        path.closePath()
        
        return path
    }
    
    class func generateStarPoints() -> UIBezierPath {
    
        let starPath = UIBezierPath()
        starPath.moveToPoint(CGPointMake(64, 0))
        starPath.addLineToPoint(CGPointMake(82.7, 38.26))
        starPath.addLineToPoint(CGPointMake(124.87, 44.22))
        starPath.addLineToPoint(CGPointMake(94.27, 73.83))
        starPath.addLineToPoint(CGPointMake(101.62, 115.78))
        starPath.addLineToPoint(CGPointMake(64, 95.82))
        starPath.addLineToPoint(CGPointMake(26.38, 115.78))
        starPath.addLineToPoint(CGPointMake(33.73, 73.83))
        starPath.addLineToPoint(CGPointMake(3.13, 44.22))
        starPath.addLineToPoint(CGPointMake(45.3, 38.26))
        starPath.closePath()
    
        return starPath
    }
    
    class func generateLeftArrow(size size: CGSize, lineWidth: CGFloat) -> UIBezierPath {
    
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(size.width - lineWidth, lineWidth))
        bezierPath.addLineToPoint(CGPointMake(lineWidth, size.height / 2))
        bezierPath.addLineToPoint(CGPointMake(size.width - lineWidth, size.height - lineWidth))
        bezierPath.lineWidth = lineWidth
        bezierPath.lineCapStyle = .Round
        bezierPath.lineJoinStyle = .Round
        
        return bezierPath
    }
    
    class func generateRightArrow(size size: CGSize, lineWidth: CGFloat) -> UIBezierPath {
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(lineWidth, lineWidth))
        bezierPath.addLineToPoint(CGPointMake(size.width - lineWidth, size.height / 2))
        bezierPath.addLineToPoint(CGPointMake(lineWidth, size.height - lineWidth))
        bezierPath.lineWidth = lineWidth
        bezierPath.lineCapStyle = .Round
        bezierPath.lineJoinStyle = .Round
                
        return bezierPath
    }
}

// ============================================================================
// MARK: CAShapeLayer
// ============================================================================

// helper method to convert degrees to radians
private func degree2radian(arc: CGFloat) -> CGFloat {
    return ( CGFloat(M_PI) * arc ) / 180
}

extension CAShapeLayer {
    func setupRotationWithPath(duration duration: Double, clockwise: Bool = true) {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = clockwise ? degree2radian(360) : degree2radian(-360)
        rotateAnimation.duration = duration
        rotateAnimation.cumulative = true
        rotateAnimation.repeatCount = HUGE
        // rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotateAnimation.fillMode = kCAFillModeForwards
        self.addAnimation(rotateAnimation, forKey: rotateAnimation.keyPath)
    }
}

// ============================================================================
// MARK: UIImage
// by Ignacio Nieto Carvajal - digitalleaves.com
// ============================================================================
extension UIImage {
    
    class func imageWithColor(color: UIColor?) -> UIImage {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        if let color = color {
            color.setFill()
        }
        else {
            UIColor.whiteColor().setFill()
        }
        
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func shapeImageWithBezierPath(bezierPath: UIBezierPath, fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat = 0.0) -> UIImage {
        //: 1. Normalize bezier path. We will apply a transform to our bezier path to ensure that it's placed at the coordinate axis. Then we can get its size.
        bezierPath.applyTransform(CGAffineTransformMakeTranslation(-bezierPath.bounds.origin.x, -bezierPath.bounds.origin.y))
        let size = CGSizeMake(bezierPath.bounds.size.width, bezierPath.bounds.size.height)
        
        //: 2. Initialize an image context with our bezier path normalized shape and save current context
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        //: 3. Set path
        CGContextAddPath(context, bezierPath.CGPath)
        
        //: 4. Set parameters and draw
        if let strokeColor = strokeColor {
            strokeColor.setStroke()
            CGContextSetLineWidth(context, strokeWidth)
        }
        else { UIColor.clearColor().setStroke() }
        fillColor?.setFill()
        
        CGContextDrawPath(context, .FillStroke)
        //: 5. Get the image from the current image context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //: 6. Restore context and close everything
        CGContextRestoreGState(context)
        UIGraphicsEndImageContext()
        //: Return image
        return image
    }
    
    
    class func shapeImageWithBezierPathTest(size size: CGSize, bezierPath: UIBezierPath, color: UIColor) -> UIImage? {
        
        guard size.width > 0 && size.height > 0 else {
            return nil
        }
        
        // create the graphics context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        //// Bezier Drawing
        color.setStroke()
        bezierPath.lineCapStyle = CGLineCap.Round
        bezierPath.stroke()
        
        CGContextRestoreGState(context)
        // save the image from the implicit context into an image
        let result = UIGraphicsGetImageFromCurrentImageContext()
        // cleanup
        UIGraphicsEndImageContext()
        
        return result
    }
}


// ============================================================================
// MARK: UIView
// ============================================================================
extension UIView {
    
    func applyBlur(blurStyle blurStyle: UIBlurEffectStyle) {
        
        // effect
        let blurEffect = UIBlurEffect(style: blurStyle)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        visualEffectView.frame = self.bounds

        self.addSubview(visualEffectView)
    }
    
    func applyBlurredBackgroundView(image: UIImage, blurStyle: UIBlurEffectStyle) {
        
        // effect
        let blurEffect = UIBlurEffect(style: blurStyle)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        visualEffectView.frame = self.bounds
        
        // background image
        let imageView = UIImageView(image: image)
        imageView.frame = self.frame
        imageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // apply
        let tempView = UIView(frame: self.frame)
        tempView.backgroundColor = UIColor.clearColor()
        tempView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        tempView.addSubview(imageView)
        tempView.addSubview(visualEffectView)
        self.addSubview(tempView)
    }
    
    func applyVibrancyToSubview(subview: UIView, blurEffect: UIBlurEffect) {
        // sau pe UIVisualEffectView cu blur
        // efectul e pe .effect
        // ... apoi la sfarsit
        // UIVisualEffectView  blurview.contentView.addSubview(vibrancyEffectView)
        
        //tableview
        //self.backgroundView = blurredBackgroundView
        //self.separatorEffect = UIVibrancyEffect(forBlurEffect: blurredBackgroundView.blurView.effect as! UIBlurEffect)

        
        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffect)
        let visualEffectView = UIVisualEffectView(effect: vibrancy)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        visualEffectView.frame = self.frame
        visualEffectView.contentView.addSubview(subview)

    }
    
    func applyGradient(colors colors: [UIColor]) {
        
        guard colors.count > 1 else {
            return
        }
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.CGColor as CGColorRef }
        
        let locations = [Int](0..<colors.count).map { Double($0) / Double(colors.count-1) }
        gradientLayer.locations = locations
        
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    class func fromNib<T : UIView>() -> T {
        return NSBundle.mainBundle().loadNibNamed(String(T), owner: nil, options: nil).first! as! T
    }
}

// ============================================================================
// MARK: UITableView
// ============================================================================
extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPointMake(0, contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    func fixTableViewLayout() {
        // reduce distance to first cell
        // take into consideration a possible headerView

        let yyy = self.visibleCells.first?.frame.origin.y ?? 0
        let headerHeight = self.tableHeaderView?.frame.size.height ?? 0
        
        self.contentInset = UIEdgeInsetsMake(headerHeight - yyy, 0.0, 0.0, 0.0)
    }
    
}

// ============================================================================
// MARK: protocol extension to load UIView from Nib
//       it loads view from Nib of the same name as the class
// ============================================================================
protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiateWithOwner(self, options: nil).first as! Self
    }
}


// ============================================================================
// MARK: UIViewController
// ============================================================================
extension UIViewController {
    
    func nearestTabBarController() -> UITabBarController? {
        if self is UITabBarController {
            return self as? UITabBarController
        }
        
        let parentVC = parentViewController != nil ? parentViewController : presentingViewController
        return parentVC?.nearestTabBarController()
    }
    
    func showAlert(title title: String?, message: String?, style: UIAlertControllerStyle, sourceView: UIView? = nil, sourceRect: CGRect? = nil, barButtonItem: UIBarButtonItem? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Cancel,
            handler: {
                (alertAction: UIAlertAction!) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        // iPad code needs some additional settings for ActionSheet
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
            && style == UIAlertControllerStyle.ActionSheet {
            
            // First we set the modal presentation style to the popover style
            alert.modalPresentationStyle = UIModalPresentationStyle.Popover
            
            // Then we tell the popover presentation controller, where the popover should appear
            if let popoverPresentationController = alert.popoverPresentationController {
                // we can have either sourceView & sourceRect
                if let sourceView = sourceView, let sourceRect = sourceRect {
                    popoverPresentationController.sourceView = sourceView
                    popoverPresentationController.sourceRect = sourceRect
                }
                else {
                    // or barButtonItem
                    if let barButtonItem = barButtonItem {
                        popoverPresentationController.barButtonItem = barButtonItem
                    }
                }
            }
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlertWithOptions(title title: String?, message: String?, style: UIAlertControllerStyle, options: [String]?, action: (((String) -> ())?), sourceView: UIView? = nil, sourceRect: CGRect? = nil, barButtonItem: UIBarButtonItem? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        // dismiss button
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Cancel,
            handler: {
                (alertAction: UIAlertAction!) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        // options
        if let options = options {
            for option in options {
                alert.addAction(UIAlertAction(title: option,
                    style: UIAlertActionStyle.Default,
                    handler: {
                        (alertAction: UIAlertAction!) -> Void in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        if let action = action {
                            action(option)
                        }
                }))
            }
        }
        
        // iPad code needs some additional settings for ActionSheet
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
            && style == UIAlertControllerStyle.ActionSheet {
                
                // First we set the modal presentation style to the popover style
                alert.modalPresentationStyle = UIModalPresentationStyle.Popover
                
                // Then we tell the popover presentation controller, where the popover should appear
                if let popoverPresentationController = alert.popoverPresentationController {
                    // we can have either sourceView & sourceRect
                    if let sourceView = sourceView, let sourceRect = sourceRect {
                        popoverPresentationController.sourceView = sourceView
                        popoverPresentationController.sourceRect = sourceRect
                    }
                    else {
                        // or barButtonItem
                        if let barButtonItem = barButtonItem {
                            popoverPresentationController.barButtonItem = barButtonItem
                        }
                    }
                }
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setBarButton(title title: String?,
        font: UIFont,
        imageNormal: String,
        imageSelected: String,
        titleNormalColor: UIColor,
        titleSelectedColor: UIColor) {
            
            let normalImage = UIImage(named: imageNormal)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            let normalSelectedImage = UIImage(named: imageSelected)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            
            let margin : CGFloat = 6.0
            
            if let title = title {
                self.tabBarItem = UITabBarItem(title: title, image: normalImage, selectedImage: normalSelectedImage)
                
                self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: font,
                    NSForegroundColorAttributeName: titleNormalColor], forState: UIControlState.Normal)
                self.tabBarItem.setTitleTextAttributes([NSFontAttributeName: font,
                    NSForegroundColorAttributeName: titleSelectedColor], forState: UIControlState.Selected)
            }
            else {
                self.tabBarItem = UITabBarItem(title: nil, image: normalImage, selectedImage: normalSelectedImage)
                self.tabBarItem.imageInsets = UIEdgeInsetsMake(margin, 0.0, -margin, 0.0);
            }
    }
    
    
    func topBarHeight() -> CGFloat {
    
        var topBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        if let navigationHeight = self.navigationController?.navigationBar.frame.size.height {
            topBarHeight += navigationHeight
        }
    
        return topBarHeight
    }
    
    func addBackImage() {
        if let backImage = UIImage(named: "back_ico") {
            let backButton = UIButton(type: .Custom)
            backButton.setBackgroundImage(backImage, forState: .Normal)
            backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height)
            backButton.userInteractionEnabled = true
            backButton.addAction { [unowned self] sender in
                // if you're referencing self, use [unowned self] above to prevent
                // a retain cycle
                
                // your code here
                self.navigationController?.popViewControllerAnimated(true)
            }
            let backButtonItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = backButtonItem
        }
    }
}

// ============================================================================
// MARK: MFMailComposeViewController
// ============================================================================
extension MFMailComposeViewController {
    
    class func showMailInterface(subject subject: String, to: [String], body: String?, parent: UIViewController?) {
        
        // print("======= emailing to: \(to.first)")
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailer = MFMailComposeViewController()
            
            // delegate
            if let parentDelegate = parent as? MFMailComposeViewControllerDelegate {
                mailer.mailComposeDelegate = parentDelegate
            }
            
            // fields
            mailer.setToRecipients(to)
            mailer.setBccRecipients(nil)
            mailer.setSubject(subject)
            if let body = body {
                mailer.setMessageBody(body, isHTML: false)
            }
            
            // NSData *imageData = UIImageJPEGRepresentation(model.originalImage, 0.7);
            // [mailer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"Broadtags_image.jpg"]];
            
            // show the composer
            parent?.presentViewController(mailer, animated: true, completion: nil)
        }
        else {
            parent?.showAlert(title: nil, message: "Email is not supported", style: UIAlertControllerStyle.Alert)
        }
    }
}


extension UIViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/*
extension UIViewController: UIPopoverPresentationControllerDelegate {

    func showPopup(sender: AnyObject, preferredContentSize: CGSize) {
        
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier(ControlCenter.popupViewName) as! APPopupViewController
        popoverContent.preferredContentSize = preferredContentSize
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        var popoverController = popoverContent.popoverPresentationController
        
        // UIPopoverPresentationControllerDelegate Protocol
        popoverController!.delegate = self
        
        popoverController!.sourceView = sender as! UIView
        popoverController!.sourceRect = (sender as! UIView).bounds
        // sau, ca sa arate catre un buton
        //popoverController?.barButtonItem = item
        
        popoverController!.permittedArrowDirections = .Any
        popoverController!.backgroundColor = ControlCenter.dominantColor
        //popoverController!.popoverBackgroundViewClass = custom UIPopoverBackgroundView
        
        self.presentViewController(popoverContent, animated: true, completion: completePresentation)
        
    }
    
    func completePresentation() {
        //println("gata")
    }
    
    public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return UIModalPresentationStyle.None

    }
*/

// ============================================================================
// MARK: UITextField
// ============================================================================
extension UITextField {
    
    func setupTheme(borderColor
        borderColor: UIColor?,
        borderWidth: CGFloat?,
        backgroundColor: UIColor,
        cornerRadius: CGFloat,
        textColor: UIColor,
        textFont: UIFont,
        placeholderText: String,
        placeholderColor: UIColor,
        placeholderFont: UIFont
        ) {
            
            // most used settings
            self.keyboardType = UIKeyboardType.EmailAddress
            self.autocapitalizationType = UITextAutocapitalizationType.None
            self.autocorrectionType = UITextAutocorrectionType.No
            self.clearButtonMode = UITextFieldViewMode.WhileEditing
            self.returnKeyType = UIReturnKeyType.Default
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            
            if let borderWidth = borderWidth, let borderColor = borderColor {
                self.layer.borderColor = borderColor.CGColor
                self.layer.borderWidth = borderWidth
            }
            self.layer.cornerRadius = cornerRadius
            self.layer.backgroundColor = backgroundColor.CGColor
            
            self.font = textFont
            self.textColor = textColor
            
            self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: placeholderFont])
    }
    
    
    func setupAccessoryRightButton(title title: String,
        target: AnyObject,
        action: Selector,
        textColor: UIColor,
        textFont: UIFont?) {
            
            let availableWidth = self.frame.size.width / 2
            let availableHeight = self.frame.size.height * 0.8
            var titleSize = CGSizeZero
            if let textFont = textFont {
                titleSize = title.sizeOfString(constrainedToWidth: availableWidth, height: availableHeight, font: textFont)
            }
            else {
                titleSize = title.sizeOfString(constrainedToWidth: availableWidth, height: availableHeight, font: self.font!)
            }
            
            
            let button = UIButton(frame: CGRectMake(0, 0, titleSize.width, availableHeight))
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitleColor(textColor, forState: UIControlState.Normal)
            button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            
            if let textFont = textFont {
                button.titleLabel?.font = textFont
            }
            else {
                button.titleLabel?.font = self.font
            }
            
            button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
            
            self.rightView = button;
            self.rightViewMode = UITextFieldViewMode.Always
    }
    
    func setupAccessoryLeftView(imageName imageName: String, scaleFactor: CGFloat) {
        
        let availableHeight = self.frame.size.height * scaleFactor
        
        let leftView = UIImageView(frame: CGRectMake(0, 0, availableHeight, availableHeight))
        
        leftView.contentMode = UIViewContentMode.ScaleAspectFit
        leftView.image = UIImage(named: imageName)
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func setupAccessoryRightButton(imageName imageName: String, scaleFactor: CGFloat?, target: AnyObject?, action: Selector) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return
        }
        
        var availableHeight : CGFloat = 22
        if let scaleFactor = scaleFactor {
            availableHeight = self.frame.size.height * scaleFactor
        }
        
        let button = UIButton(frame: CGRectMake(0, 0, availableHeight, availableHeight))
        
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.contentMode = UIViewContentMode.ScaleAspectFit
        button.clipsToBounds = true
        button.setImage(buttonImage, forState: UIControlState.Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        self.rightView = button
        self.rightViewMode = UITextFieldViewMode.Always
    }
    
    func rightButton() -> UIButton? {
        if let rightView = rightView where rightView is UIButton {
            return rightView as? UIButton
        }
        
        return nil
    }
    
}




// ============================================================================
// MARK: UINavigationBar
// ============================================================================
extension UINavigationBar {
    
    class func setNavigationBar(barStyle barStyle: UIBarStyle = UIBarStyle.Default, translucent: Bool = true, tintColor: UIColor, bgColor: UIColor, font: UIFont, fontButtons: UIFont) {
        
        // style
        UINavigationBar.appearance().barStyle = barStyle
        // bar bg color
        UINavigationBar.appearance().barTintColor = bgColor
        // bar tint color
        UINavigationBar.appearance().tintColor = tintColor
        // bar title font
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font,
            NSForegroundColorAttributeName: tintColor]
        
        // butoane - tint color, white pentru bg colorat
        UIBarButtonItem.appearance().tintColor = tintColor
        // butoane - font
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: fontButtons],
            forState: UIControlState.Normal)
    }
    
    class func removeNavigationBarShadow() {
        // remove bottom shadow
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }
    
    class func setupTransparentLight() {
        UINavigationBar.removeNavigationBarShadow()
        UINavigationBar.appearance().backgroundColor = UIColor.clearColor()
        UINavigationBar.appearance().translucent = true
        
//        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: Design.Fonts.Headline.font,
//            NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
}

// ============================================================================
// MARK: UITabBar
// ============================================================================
extension UITabBar {
    
    class func removeTabBarShadow() {
        // remove upper line
        UITabBar.appearance().shadowImage = UIImage()
        //UITabBar.appearance().backgroundImage = UIImage()
    }
    
    class func setTabBar(barStyle barStyle: UIBarStyle, translucent: Bool, tintColor: UIColor, bgColor: UIColor) {
        UITabBar.appearance().barStyle = barStyle
        UITabBar.appearance().translucent = translucent
        UITabBar.appearance().tintColor = tintColor
        UITabBar.appearance().barTintColor = bgColor
        UITabBar.appearance().backgroundImage = UIImage.imageWithColor(bgColor)
        UITabBar.appearance().itemPositioning = UITabBarItemPositioning.Automatic
    }
}

// ============================================================================
// MARK: UIButton
// ============================================================================
var ButtonAssociatedObjectHandle: UInt8 = 0

class ClosureWrapper : NSObject {
    var block : (sender: UIButton) -> Void
    init(block: (sender: UIButton) -> Void) {
        self.block = block
    }
}

extension UIButton {
    
    func addAction(forControlEvents events: UIControlEvents = UIControlEvents.TouchUpInside, block: (sender: UIButton) -> Void) {
        let wrapper = ClosureWrapper(block: block)
        objc_setAssociatedObject(self, &ButtonAssociatedObjectHandle, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(UIButton.block_handleAction(_:)), forControlEvents: events)
    }
    
    func block_handleAction(sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ButtonAssociatedObjectHandle) as! ClosureWrapper
        wrapper.block(sender: sender)
    }
    
    func setupTheme(borderColor
        borderColor: UIColor,
        borderWidth: CGFloat,
        backgroundColorNormal: UIColor,
        backgroundColorHighlighted: UIColor,
        cornerRadius: CGFloat,
        titleColor: UIColor,
        title: String? = nil,
        titleFont: UIFont
        ) {
            
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            self.layer.borderColor = borderColor.CGColor
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            
            self.titleLabel?.font = titleFont
            
            if let title = title {
                self.setTitle(title, forState: UIControlState.Normal)
            }
            
            self.setTitleColor(titleColor, forState: UIControlState.Normal)
            self.setTitleColor(titleColor, forState: UIControlState.Highlighted)
            
            self.setBackgroundImage(UIImage.imageWithColor(backgroundColorNormal), forState: UIControlState.Normal)
            self.setBackgroundImage(UIImage.imageWithColor(backgroundColorHighlighted), forState: UIControlState.Highlighted)
    }
    
    
    func setupImage(image: UIImage) {
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.contentMode = UIViewContentMode.ScaleAspectFit
        // self.layer.masksToBounds = true
        self.clipsToBounds = true
        // self.layer.borderColor = UIColor.greenColor().CGColor
        // self.layer.borderWidth = 1
        self.setImage(image, forState: UIControlState.Normal)
    }
    
    
    convenience init?(imageName: String, diameter: CGFloat?, block: (sender: UIButton) -> Void) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return nil
        }
        
        let buttonDiameter : CGFloat = diameter ?? 22

        self.init(frame: CGRectMake(0, 0, buttonDiameter, buttonDiameter))
        
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.contentMode = UIViewContentMode.ScaleAspectFit
        self.clipsToBounds = true
        self.setImage(buttonImage, forState: UIControlState.Normal)
        self.addAction(block: block)
        
        // button.showsTouchWhenHighlighted = true
        // button.layer.borderColor = UIColor.whiteColor().CGColor
        // button.layer.borderWidth = 1
    }
    
    convenience init?(imageName: String, diameter: CGFloat?, target: AnyObject?, action: Selector) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return nil
        }
        
        let buttonDiameter : CGFloat = diameter ?? 22
        
        self.init(frame: CGRectMake(0, 0, buttonDiameter, buttonDiameter))
        
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.contentMode = UIViewContentMode.ScaleAspectFit
        self.clipsToBounds = true
        self.setImage(buttonImage, forState: UIControlState.Normal)
        self.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        // button.showsTouchWhenHighlighted = true
        // button.layer.borderColor = UIColor.whiteColor().CGColor
        // button.layer.borderWidth = 1
    }
    
}

// ============================================================================
// MARK: UIBarButtonItem
// ============================================================================
extension UIBarButtonItem {
    
    convenience init?(imageName: String, target: AnyObject?, action: Selector) {
        
        guard let buttonImage = UIImage(named: imageName) else {
            return nil
        }
        
        let button = UIButton(frame: CGRectMake(0, 0, 22, 22))
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.contentMode = UIViewContentMode.ScaleAspectFit
        button.clipsToBounds = true
        button.setImage(buttonImage, forState: UIControlState.Normal)
        // button.showsTouchWhenHighlighted = true
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        // button.layer.borderColor = UIColor.whiteColor().CGColor
        // button.layer.borderWidth = 1
        
        self.init(customView: button)
    }

}

// ============================================================================
// MARK: UISearchBar
// ============================================================================
extension UISearchBar {
    
    func getTextField() -> UITextField? {
        
        let searchTextViews = self.subviews.recursiveFlatMap(
            { $0 as? UITextField },
            children: { $0.subviews })
        if let searchTextView = searchTextViews.first {
            return searchTextView
        }
    
        return nil
    }
    
}

extension NSUserDefaults {
    func saveToKey(key: String, dictionary: [String: String]) {
        self.setObject(dictionary, forKey: key)
        self.synchronize()
    }
    
    func deleteKey(key: String) {
        self.removeObjectForKey(key)
        self.synchronize()
    }
    
    func keyExists(key: String) -> Bool {
        if let dictionary = self.objectForKey(key) as? [String: String] {
            if dictionary.count > 0 {
                return true
            }
        }
        return false
    }
}


// MARK: date extension
extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}



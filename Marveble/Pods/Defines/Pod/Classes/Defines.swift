import UIKit

public struct Defines
{
    public struct Screen
    {
        public static let Width = UIScreen.mainScreen().bounds.size.width
        public static let Height = UIScreen.mainScreen().bounds.size.height
        public static let MaxLength = max(Screen.Width, Screen.Height)
        public static let MinLength = min(Screen.Width, Screen.Height)
        public static let IsRetina = UIScreen.mainScreen().scale > 1
    }
    
    public struct Device
    {
        public static let IsiPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
        public static let IsiPhone4OrLess =  !IsiPad && Screen.MaxLength < 568.0
        public static let IsiPhone5 = !IsiPad && Screen.MaxLength == 568.0
        public static let IsiPhone6 = !IsiPad && Screen.MaxLength == 667.0
        public static let IsiPhone6p = !IsiPad && Screen.MaxLength == 736.0
#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
        public static let IsSimulator = true
#else
        public static let IsSimulator = false
#endif
        
    }
    
    public struct Version
    {
        public static let IsiOS7 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue < 8.0
        public static let IsiOS8 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue < 9.0
        public static let IsiOS9 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue < 10.0
    }
    
    public struct App
    {
        public static let IsScaledUp = Device.IsiPhone6p && UIScreen.mainScreen().nativeScale > UIScreen.mainScreen().scale
        public static func BundleId() -> String {
            return NSBundle.mainBundle().bundleIdentifier!
        }
        public static let Name = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
    }
}

import UIKit


private class UILoaderItem
{
    weak var item: UILoader?
    var count: Int = 0
    init(item: UILoader) {
        self.item = item
    }
    
    private static var all = [UILoaderItem]()
    
    static func find(item: UILoader) -> UILoaderItem?
    {
        for existing in all {
            if let tempItem = existing.item {
                if tempItem.isEqual(item) {
                    return existing
                }
            }
        }
        return nil
    }
    
    static func make(item: UILoader) -> UILoaderItem
    {
        if let found = find(item) {
            return found
        }
        all.append(UILoaderItem(item: item))
        return all.last!
    }
}


public protocol UILoader: NSObjectProtocol
{
    var loading: Bool { get set }
    weak var spinningThing: UIActivityIndicatorView? { get }
    func didChangeLoadingStatus(loading: Bool)
}


public extension UILoader
{
    public var loading: Bool {
        get {
            return UILoaderItem.make(self).count > 0
        }
        set {
            let oldValue = self.loading
            let loaderItem = UILoaderItem.make(self)
            
            var shouldNotify = false
            
            if newValue {
                loaderItem.count += 1
                shouldNotify = loaderItem.count == 1
            } else {
                loaderItem.count -= 1
                shouldNotify = loaderItem.count == 0
                if loaderItem.count < 0 {
                    loaderItem.count = 0
                }
            }
            
            if (newValue != oldValue && shouldNotify)
            {
                let status = self.notifyStatusChange
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    status(newValue)
                }
            }
        }
    }
    
    private func notifyStatusChange(newValue: Bool) {
        if newValue {
            self.spinningThing?.startAnimating()
        } else {
            self.spinningThing?.stopAnimating()
        }
        self.didChangeLoadingStatus(newValue)
    }
}

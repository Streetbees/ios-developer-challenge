import Foundation

class BaseViewModel {
    
    var active: Bool = false {
        didSet {
            if active {
                didBecomeActive()
            }
        }
    }
    
    func didBecomeActive() {
    }
}

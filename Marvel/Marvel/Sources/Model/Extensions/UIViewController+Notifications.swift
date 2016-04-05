import UIKit
import Whisper

extension UIViewController {
    
    func showInfo(text: String) {
        showMessage(text, colour: UIColor.info())
    }
    
    func showError(text: String) {
        showMessage(text, colour: UIColor.error())
    }
    
    func showSuccess(text: String) {
        showMessage(text, colour: UIColor.success())
    }
    
    func silentNotification() {
        guard let nav = self.navigationController else { return }
        Silent(nav)
    }
    
    private func showMessage(text: String, colour: UIColor, silentAfter: NSTimeInterval = 3) {
        guard let nav = self.navigationController else { return }
        
        Config.modifyInset = false
        
        let message = Message(title: text, backgroundColor: colour)
        Whisper(message, to: nav, action: .Present)
        Silent(nav, after: 3)
    }
    
}

import Foundation

class ComicCellViewModel: BaseViewModel {
    
    var model: Comic {
        didSet {
            modelWasUpdated()
        }
    }
    
    init(model: Comic) {
        self.model = model
        
        super.init()
    }
    
    override func didBecomeActive() {
        modelWasUpdated()
    }
    
    func modelWasUpdated() {
    }

}
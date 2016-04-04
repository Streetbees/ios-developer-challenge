import Foundation
import RxSwift

class ComicDetailsViewModel: BaseViewModel {
    
    var title       = PublishSubject<String>()
    var thumbnail   = PublishSubject<UIImage?>()
    var details     = PublishSubject<[String]>()
    
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
        guard let comicTitle = model.title where !comicTitle.isEmpty else { return }

        let desc = model.description ?? "No description available for this comic."
        
        title.on(.Next(comicTitle))
        details.on(.Next([desc]))
        thumbnail.on(.Next(model.thumbnail))
    }
}

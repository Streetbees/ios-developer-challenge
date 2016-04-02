import Foundation
import RxSwift

class ComicsViewModel: BaseViewModel {

    let marvelAPI: MarvelComicsAPI
    
    private let limit = 20 // number of results loaded each time: should not change
    var offset = 0
    //var count = 0
    // var total = 0
    
    var comics = PublishSubject<[ComicCellViewModel]>()
    
    var model: [Comic] = [] {
        didSet {
            modelWasUpdated()
        }
    }
    
    init(marvelAPI: MarvelComicsAPI = MarvelAPI.api) {
        self.marvelAPI = marvelAPI
    }
    
    override func didBecomeActive() {
        fetchData()
    }
    
    func modelWasUpdated() {
        let cellsViewModels = model.map { ComicCellViewModel(model: $0) }
        comics.on(.Next(cellsViewModels))
    }
    
    func fetchData() {
        marvelAPI.listComics({ comicData in
            print("Sucess: \(comicData.comics)")
            
            //self.offset = offset
            //self.total = total
                        
            if let moreComics = comicData.comics {
                self.model += moreComics
            }
            
        }, onFailure: { requestFailed in
            print("Failed... : \(requestFailed.description)")
            self.comics.on(.Error(requestFailed)) // if the list had comics already, it should still be presented
        })
    }
}

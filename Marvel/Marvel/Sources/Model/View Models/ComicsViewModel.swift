import Foundation
import RxSwift

private let defaultLimit = 30

class ComicsViewModel: BaseViewModel {

    let marvelAPI: MarvelComicsAPI
    var isLoadingData = false
    var currentOffset = 0
    
    var comics = PublishSubject<([Comic])>()
    
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
        comics.on(.Next(model))
    }
    
    func fetchData() {
        fetchNextBatchOfComics()
    }
    
    func fetchNextBatchOfComics() {
        if !isLoadingData {
            isLoadingData = true
            
            marvelAPI.listComics(currentOffset, limit: defaultLimit, onSuccess: successfulyLoadedComics, onFailure: failedToLoadComics)
        }
    }
    
    func successfulyLoadedComics(comicData: ComicDataContainer) {
        guard let moreComics = comicData.comics, count = comicData.count else {
            isLoadingData = false
            return
        }
        
        model += moreComics
        currentOffset += count
        
        isLoadingData = false
    }
    
    func failedToLoadComics(requestFailed: RequestFailed) {
        print("Failed... : \(requestFailed.description)")
        comics.on(.Error(requestFailed))
        isLoadingData = false
    }
}

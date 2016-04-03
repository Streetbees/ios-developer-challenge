import Foundation
import RxSwift

private let defaultLimit = 20

class ComicsViewModel: BaseViewModel {

    let marvelAPI: MarvelComicsAPI
    let disposeBag = DisposeBag()
    
    var isLoadingData = false
    var currentOffset = 0
    
    var comics = PublishSubject<[Comic]>()
    var thumbnailLoaded = PublishSubject<(Int, Comic)>()
    
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
        
        ImageLoaderService.service.loadedImage
            .subscribeNext { (comic, image) in
                if let index = self.model.indexOf({ $0 == comic }) {
                    comic.thumbnail = image
                    self.thumbnailLoaded.onNext((index, comic))
                }
            }
            .addDisposableTo(disposeBag)
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
        
        moreComics.forEach(ImageLoaderService.service.loadComicThumbnail)
        
        isLoadingData = false
    }
    
    func failedToLoadComics(requestFailed: RequestFailed) {
        print("Failed... : \(requestFailed.description)")
        comics.on(.Error(requestFailed))
        isLoadingData = false
    }
}

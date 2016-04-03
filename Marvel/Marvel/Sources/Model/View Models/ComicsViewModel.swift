import Foundation
import RxSwift

class ComicsViewModel: BaseViewModel {

    let marvelAPI: MarvelComicsAPI
    let disposeBag = DisposeBag()
    
    private let limit = 20
    var offset = 0
    //var count = 0
    // var total = 0
    
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
        marvelAPI.listComics({ comicData in
            // TODO: deal with paging (offset, count, total...)

            if let moreComics = comicData.comics {
                self.model += moreComics
                moreComics.forEach(ImageLoaderService.service.loadComicThumbnail)
            }
            
        }, onFailure: { requestFailed in
            print("Failed... : \(requestFailed.description)")
            self.comics.on(.Error(requestFailed)) // if the list had comics already, it should still be presented
        })
    }
}

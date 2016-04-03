import Foundation
import RxSwift

class ImageLoaderService {
    static let service = ImageLoaderService()
    private init() {}
    
    var loadedImage = PublishSubject<(Comic, UIImage)>()
    
    func loadComicThumbnail(comic: Comic) {
        
        // TODO: check if dropbox is linked, check image on dropbox, download from dropbox or web
        
        MarvelAPI.api.loadComicThumbnail(comic, onSuccess: { image in
            let result = (comic, image)
            self.loadedImage.on(.Next(result))
        }, onFailure: { failure in
            print("Failed to load image for comic")
        })
    }
}

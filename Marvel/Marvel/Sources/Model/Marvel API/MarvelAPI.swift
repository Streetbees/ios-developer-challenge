import Foundation
import Alamofire
import Timberjack
import AlamofireImage

typealias OnFailure = RequestFailed -> Void

protocol MarvelComicsAPI {
    func listComics(onSuccess: ComicDataContainer -> Void, onFailure: OnFailure)
    func loadComicThumbnail(comic: Comic)
}

class MarvelAPI: MarvelComicsAPI {
    static let api = MarvelAPI()
    
    private let manager = Alamofire.Manager(configuration: Timberjack.defaultSessionConfiguration())
    
    private lazy var imageDownloader: ImageDownloader = {
        return ImageDownloader(sessionManager: self.manager, downloadPrioritization: .FIFO, maximumActiveDownloads: 4, imageCache: AutoPurgingImageCache())
    }()
    
    func listComics(onSuccess: ComicDataContainer -> Void, onFailure: OnFailure) {
        manager.startRequestsImmediately = true
        manager.request(Router.ListComics).responseArgo { (r: Response<ComicDataContainer, RequestFailed>) in
            switch r.result {
            case .Success(let object):
                onSuccess(object)
            case .Failure(let f):
                onFailure(f)
            }
        }
    }
    
    func loadComicThumbnail(comic: Comic) {
        guard let path = comic.thumbnailPath where !path.isEmpty, let ext = comic.thumbnailExtension where !ext.isEmpty else { return }
        
        let imageUrl = "\(path).\(ext)"
        let URLRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
        
        imageDownloader.downloadImage(URLRequest: URLRequest) { response in
            if let image = response.result.value {
                print("Image loaded successfuly: \(URLRequest)")
            }
        }
    }

}

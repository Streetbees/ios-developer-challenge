import Foundation
import Alamofire
import Timberjack
import AlamofireImage

typealias OnFailure = RequestFailed -> Void

protocol MarvelComicsAPI {
    func listComics(offset: Int, limit: Int, onSuccess: ComicDataContainer -> Void, onFailure: OnFailure)
    func loadComicThumbnail(comic: Comic, onSuccess: UIImage -> Void, onFailure: OnFailure)
}

class MarvelAPI: MarvelComicsAPI {
    static let api = MarvelAPI()
    private init() {}
    
    //private let manager = Alamofire.Manager(configuration: Timberjack.defaultSessionConfiguration())
    private let manager = Alamofire.Manager.sharedInstance
    
    private lazy var imageDownloader: ImageDownloader = {
        return ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .LIFO, maximumActiveDownloads: 6, imageCache: AutoPurgingImageCache())
    }()
    
    func listComics(offset: Int, limit: Int, onSuccess: ComicDataContainer -> Void, onFailure: OnFailure) {
        let request = Router.ListComics(offset, limit)
        
        manager.startRequestsImmediately = true
        manager.request(request).responseArgo { (r: Response<ComicDataContainer, RequestFailed>) in
            switch r.result {
            case .Success(let object):
                onSuccess(object)
            case .Failure(let f):
                onFailure(f)
            }
        }
    }
    
    func loadComicThumbnail(comic: Comic, onSuccess: UIImage -> Void, onFailure: OnFailure) {
        guard let path = comic.thumbnailPath where !path.isEmpty, let ext = comic.thumbnailExtension where !ext.isEmpty else { return }
        
        let imageUrl = "\(path).\(ext)"
        let URLRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
        
        imageDownloader.downloadImage(URLRequest: URLRequest) { r in
            switch r.result {
            case .Success(let image):
                onSuccess(image)
            case .Failure(let error):
                let failure = RequestFailed(code: .UnknownFailure, description: "Request failed: \(error.localizedDescription)")
                onFailure(failure)
            }
        }
    }

}

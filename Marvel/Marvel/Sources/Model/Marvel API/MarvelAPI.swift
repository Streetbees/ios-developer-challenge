import Foundation
import Alamofire
import Timberjack
import AlamofireImage

typealias OnFailure = RequestFailed -> ()

protocol MarvelComicsAPI {
    func listComics(offset: Int, limit: Int, onSuccess: ComicDataContainer -> (), onFailure: OnFailure)
    func downloadComicThumbnailFromMarvel(comic: Comic, completion: UIImage? -> ())
}

class MarvelAPI: MarvelComicsAPI {
    static let api = MarvelAPI()
    private init() {}
    
    //private let manager = Alamofire.Manager(configuration: Timberjack.defaultSessionConfiguration())
    private let manager = Alamofire.Manager.sharedInstance
    
    private lazy var imageDownloader: ImageDownloader = {
        return ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .LIFO, maximumActiveDownloads: 6, imageCache: AutoPurgingImageCache())
    }()
    
    func listComics(offset: Int, limit: Int, onSuccess: ComicDataContainer -> (), onFailure: OnFailure) {
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
    
    func downloadComicThumbnailFromMarvel(comic: Comic, completion: UIImage? -> ()) {
        guard let path = comic.thumbnailPath where !path.isEmpty, let ext = comic.thumbnailExtension where !ext.isEmpty else { return }
        
        let imageUrl = "\(path).\(ext)"
        let URLRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
        
        imageDownloader.downloadImage(URLRequest: URLRequest) { r in
            switch r.result {
            case .Success(let image):
                comic.thumbnail = image
                completion(image)
            case .Failure:
                completion(.None)
            }
        }
    }

}

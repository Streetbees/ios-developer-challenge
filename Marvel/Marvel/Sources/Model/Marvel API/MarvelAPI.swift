import Foundation
import Alamofire
import Timberjack

typealias OnFailure = RequestFailed -> Void

protocol MarvelComicsAPI {
    func listComics(onSuccess: ComicDataWrapper -> Void, onFailure: OnFailure)
}

class MarvelAPI: MarvelComicsAPI {
    static let api = MarvelAPI()
    
    private let manager = Alamofire.Manager(configuration: Timberjack.defaultSessionConfiguration())
        
    func listComics(onSuccess: ComicDataWrapper -> Void, onFailure: OnFailure) {
        manager.startRequestsImmediately = true
        manager.request(Router.ListComics).responseArgo { (r: Response<ComicDataWrapper, RequestFailed>) in
            switch r.result {
            case .Success(let object):
                onSuccess(object)
            case .Failure(let f):
                onFailure(f)
            }
        }
    }

}

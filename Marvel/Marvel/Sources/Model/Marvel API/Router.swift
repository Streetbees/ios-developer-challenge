import Foundation
import CryptoSwift
import Alamofire

private let baseURLString = "https://gateway.marvel.com"
private let version = "v1"
private let publicKey = "f2db8b5ba4d87bd481d5b43a2702814b"
private let privateKey = "eb4a7ff3a919ab84cd6022bd5eb6179529629046"

enum Router {
    case ListComics(Int, Int)
    
    var method: Alamofire.Method {
        switch self {
        case .ListComics:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .ListComics:
            return "public/comics"
        }
    }
    
    var defaultParameters: [String : AnyObject] {
        let ts = String(NSDate().timeIntervalSince1970)
        let hash = "\(ts)\(privateKey)\(publicKey)".md5()
        
        return [
            "ts": ts,
            "apikey": publicKey,
            "hash": hash,
        ]
    }
}

extension Router: URLRequestConvertible {
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: "\(baseURLString)/\(version)")!
        var request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        request.HTTPMethod = method.rawValue
        
        // Add default parameters required by the API for every request
        request = Alamofire.ParameterEncoding.URL.encode(request, parameters: defaultParameters).0
        
        switch self {
        case .ListComics(let offset, let limit):
            let parameters: [String : AnyObject] = [
                "offset": offset,
                "limit": limit,
                "orderBy": "-onsaleDate",
            ]
            
            request = Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
            return request
        }
    }
}

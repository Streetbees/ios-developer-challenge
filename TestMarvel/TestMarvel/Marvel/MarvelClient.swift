//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import Alamofire
import Gloss
import CryptoSwift

class MarvelClient {
    let marvelKey = "90f4682ce245c17e75398bbe46ff695a"
    let privateKey = "9496bde7ab0bd95805ed8148aecc0fd439141625"
    let apiUrl = "http://gateway.marvel.com:80/v1/public/"
    let pageCount = 30

    init() {
    }

    internal func urlFor(query: String) -> String {
        return apiUrl+query;
    }

    func getComics(offset: Int = 0, limit: Int = 30, completeHandler: (MarvelClientResult) -> Void) {
        let ts = String(NSDate.init().timeIntervalSince1970)
        
        Alamofire.request(.GET, urlFor("comics"), parameters: [
            "format": "comic",
            "formatType": "comic",
            "orderBy": "-onsaleDate",
            "apikey": marvelKey,
            "offset": offset,
            "limit": limit,
            "ts": ts,
            "hash": (ts+privateKey+marvelKey).md5()
        ])
        .responseJSON { response in
            switch response.result {
                case .Success(let data):
                    guard let marvelRes = ComicDataWrapper(json: data as! JSON) else {
                        completeHandler(.Error("Error downloading comics from Marvel"))
                        return;
                    }
                    
                    completeHandler(.Success(marvelRes))

                case .Failure(let err):
                    print("Error comics \(err.description)")
                    completeHandler(.Error("Error downloading comics from Marvel"))
            }
        }
    }
}

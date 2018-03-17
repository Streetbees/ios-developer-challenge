//
//  ComicManager.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 17/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

protocol ComicManagerDelegate: class {
    func loaded(comics c: [Comic])
    func failed(toLoadComicsWith error: String)
}

class ComicManager {
    
    var currentComicCount : Int = 0
    
    var fullyLoaded : Bool = false
    
    let requestManager = RequestManager.shared
    
    weak var delegate : ComicManagerDelegate?
    
    func getComics() {
        
        var url = URLComponents(string: "https://gateway.marvel.com:443/v1/public/comics")!
        
        let timeStamp = Date().timeIntervalSince1970
        
        url.queryItems = [
            URLQueryItem(name: "offset", value: currentComicCount.description),
            URLQueryItem(name: "apikey", value: "b2164a8a4227fe9c8de18b3b1c863c8c"),
            URLQueryItem(name: "ts", value: timeStamp.description),
            URLQueryItem(name: "hash", value: md5(timeStamp.description + "56306f39f12ad7980bc0434d3cad354933ef2d3d" + "b2164a8a4227fe9c8de18b3b1c863c8c")),
        ]
        
        guard let requestURL = url.url else { return }
        
        requestManager.get(requestWith: requestURL) { (success, data, error) in
        
            guard let jsonData = data?["data"] as? JSON,
                    let total = jsonData["total"] as? Int,
                    let comics = jsonData["results"] as? [JSON] else { return }
        
            self.currentComicCount += comics.count
        
            var c : [Comic] = []
            
            comics.forEach {
                c.append(Comic(with: $0))
            }
            
            if self.currentComicCount == total {
                self.fullyLoaded = true
            } else {
                self.delegate?.loaded(comics: c)
            }
            
        }
        
    }
    
}

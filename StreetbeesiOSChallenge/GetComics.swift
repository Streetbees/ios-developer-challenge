//
//  GetComics.swift
//  StreetbeesiOSChallenge
//
//  Created by Joe Kletz on 28/10/2017.
//  Copyright © 2017 Joe Kletz. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftHash
import SwiftyJSON

protocol GetComicDelegate {
    func receivedComicData(comics:[Comic])
}


class GetComicsNetworkService {
    
    var delegate:GetComicDelegate?
    
    var comics:[Comic] = []
    
    var loading = false
    
    var parameters:Parameters = [:]
    
    func getComics(offset:Int) {

        getParameters(offset: offset)
        
        request(urlString: "http://gateway.marvel.com/v1/public/comics") { json in
            
            let data = json["data"]["results"].array
            
            for item in data! {
                let comic = Comic(json: item)
                self.comics.append(comic)
            }
            
            self.delegate?.receivedComicData(comics: self.comics)
        }
    }
    
    func getParameters(offset:Int) {
        
        loading = true
        
        let timeStamp = Int(Date().timeIntervalSince1970)
        let publicKey = "f7463d1d289051d839442b53ed17e674"
        let privateKey = "0001bb5ac381b6504784fa1cde9fb0fab4b948e1"
        let hash = MD5(String(timeStamp) + privateKey + publicKey).lowercased()
        
        parameters = [
            "apikey": publicKey,
            "ts": timeStamp,
            "hash": hash,
            
            "orderBy":"-focDate",
            
            "limit":"20",
            "offset": String(offset)
        ]
    }
    
    func request(urlString:String, completion: @escaping (JSON) -> Void ) {

        
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                print("Success")
                
                self.loading = false
                let json = JSON(value)
                completion(json)
                
            case .failure(let error):
                print(error)
                self.loading = false
            }
        }
    }
}

struct Comic {
    var thumbnailURL:String?
    var id:Int?
    var title:String?
    var coverURL:String?
    var description:String?
    var characters:[String] = []
}

extension Comic{
    init(json:JSON) {

        id = json["id"].intValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        
        let items = json["characters"]["items"].arrayValue
        
        for item in items {
            let character = item["name"].stringValue
            characters.append(character)
        }
        
        let imagePath = json["thumbnail"]["path"].stringValue
        let ext = json["thumbnail"]["extension"].stringValue
        
        thumbnailURL = imagePath + "/portrait_medium." + ext
        coverURL = imagePath + "/portrait_uncanny." + ext
    }
}

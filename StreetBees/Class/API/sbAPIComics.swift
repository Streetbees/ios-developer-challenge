//
//  sbAPIComics.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


class APIComics
{
    // MARK: - Property(s)
    
    private(set) lazy var jsonService: JSONService =
    { [unowned self] in
        
        let anObject = JSONService()
        anObject.session = URLSession.shared
        return anObject
    }()
    
    
    // MARK: - Fecting API Comics
    
    func fetch(_ queryItems: [URLQueryItem],
               cachePolicy: URLRequest.CachePolicy,
               completion: @escaping ([Comic]) -> Void)
    {
        guard let request = URLRequest.resource(path: "/\(APIPath.comics.rawValue)",
            queryItems: queryItems) else
        {
            completion([])
            return
        }
        
        self.jsonService.resource(request)
        { (jsonObject, error) in
            
            guard let jsonObject = jsonObject,
                let data = jsonObject[APIKeys.data.rawValue] as? JSONObject,
                let results = data[APIKeys.results.rawValue] as? [JSONObject] else
            { return }
            
            var buffer: [Comic] = []
            for object in results
            {
                guard let comic = Comic.compile(jsonObject: object) else
                { continue }
                buffer.append(comic)
            }
            completion(buffer)
        }
    }
}


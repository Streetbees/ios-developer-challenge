//
//  MarvelService.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

struct MarvelService {
    
    private let api: MarvelAPI
    
    init(api: MarvelAPI) {
        self.api = api
    }
    
    func getComics(offset: Int, completionHandler: @escaping NetworkRequestCompletionHandler) {
        api.getComics(request: ComicRouter.comics(offset: offset)) { (data, error) in
            completionHandler(data, error)
        }
    }
}

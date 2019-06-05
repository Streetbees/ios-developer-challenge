//
//  AlamofireMarvelAPI.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireMarvelAPI: MarvelAPI {

    func getComics(request: URLRequestConvertible, completionHandler: @escaping NetworkRequestCompletionHandler) {
        
        Alamofire.request(request).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandler(response.data, nil)
            case .failure:
                completionHandler(nil, response.error)
            }
        }
    }
}

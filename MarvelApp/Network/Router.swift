//
//  Router.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift

fileprivate struct MarvelAuthConfig {
    static let privatekey = Konstants.Network.privateKey.rawValue
    static let apikey = Konstants.Network.apiKey.rawValue
    static let ts = Date().timeIntervalSince1970.description
    static let hash = "\(ts)\(privatekey)\(apikey)".md5()
}

enum ComicRouter: URLRequestConvertible {
    
    case comics(offset: Int)
    case comic(id: String)
    
    static let baseURLString = Konstants.Network.comicsBaseURL.rawValue
    
    private var method: HTTPMethod {
        switch self {
        case .comics, .comic:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .comics:
            return "/comics"
        case .comic(let id):
            return "/comics/\(id)"
        }
    }
    
    func authParameters() -> [String: String] {
        return ["apikey": MarvelAuthConfig.apikey,
                "ts": MarvelAuthConfig.ts,
                "hash": MarvelAuthConfig.hash]
    }
    
    private var parameters: Parameters? {
        switch self {
        case .comics(let offset): //OrderBy -modified
            return ["offset": offset, "orderBy": "-modified"].merging(authParameters(), uniquingKeysWith: { (current, _) in current })
        case .comic:
            return authParameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try ComicRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)

        return urlRequest
    }
}

//
//  APIService.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Alamofire

typealias DataCompletion = (Data) -> Void
typealias ComicsResultSuccess = (Response<MarvelComic>) -> Void
typealias CharacterResultSuccess = (Response<MarvelCharacter>) -> Void
typealias ServiceFailure = (ServiceError) -> Void

class APIService: APIServiceRequestable {
  
  private var manager: SessionManager!
  
  init() {
    setupHeaders()
  }
  
  private func setupHeaders() {
    var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    defaultHeaders["Accept"] = "*/*"
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = defaultHeaders
    
    manager = Alamofire.SessionManager(configuration: configuration)
  }
  
  func requestComics(offset: Int, _ completion: @escaping ComicsResultSuccess, _ failure: @escaping ServiceFailure) {
    self.request(Router.requestComics(offset), { (data) in
      do {
        let jsonDecoder = JSONDecoder()
        let response = try jsonDecoder.decode(Response<MarvelComic>.self, from: data)
        completion(response)
      } catch {
        failure(ServiceError.parseError)
      }
    }) { (error) in
      failure(error)
    }
  }
  
  func requestCharacters(comicId: Int, _ completion: @escaping CharacterResultSuccess, _ failure: @escaping ServiceFailure) {
    self.request(Router.requestCharacters(comicId), { (data) in
      do {
        let jsonDecoder = JSONDecoder()
        let response = try jsonDecoder.decode(Response<MarvelCharacter>.self, from: data)
        completion(response)
      } catch {
        failure(ServiceError.parseError)
      }
    }) { (error) in
      failure(error)
    }
  }
  
  private func request(_ urlRequest: URLRequestConvertible, _ completion: @escaping DataCompletion, _ failure: @escaping ServiceFailure) {
    manager.request(urlRequest).responseData { (response) in
      switch response.result {
      case .success(let data):
        completion(data)
      case .failure(let error):
        failure(ServiceError.networkError(message: error.localizedDescription))
      }
    }
  }
}

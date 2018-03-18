//
//  RequestManager.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 17/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

class RequestManager {
    
    static let shared = RequestManager()
    
    let session = URLSession.shared
    
    func get(imageWith urlString: String, for index: Int,
             _ completion: @escaping ((_ success: Bool,_ imageData: Data?,_ error: String?, _ index: Int) -> Void)) {
        
        guard let url = URL(string: urlString) else { return }
        
        let urlRequest = URLRequest(url: url)
        
        perform(requestWith: urlRequest, {
            (_ success: Bool,_ data: Data?,_ error: String?) in
            
            completion(success, data, error, index)
            
        })
    }
    
    func get(requestWith url: URL,_
        completion: @escaping ((_ success: Bool,_ data: JSON?,_ error: String?) -> Void)) {
        
        let request = URLRequest(url: url)
        
        perform(requestWith: request, {
            success, data, error in
            
            if success == true {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSON
                    
                    DispatchQueue.main.async {
                        completion(true, json, nil)
                    }
                    
                } catch let error as NSError {
                    completion(false, nil, error.description)
                }
            }
            
        })
    }
    
    
    private func perform(requestWith urlRequest: URLRequest, _
        completion: @escaping ((_ success: Bool,_ data: Data?,_ error: String?) -> Void)) {
        
        session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                completion(false, nil, nil)
                return
            }
            switch urlResponse.statusCode {
            case 200:
                completion(true, data, nil)
            case 400:
                print(urlRequest)
                break
            default:
                break
            }
            print(urlResponse.statusCode)
            }.resume()
        
        
    }
}


//
//  sbSessionService.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


struct TaskData
{
    let data: Data?
    let type: ContentType
}

typealias DataTaskResponseCallback = (TaskData?, Error?) -> Void

class DataService
{
    // MARK: - Property(s)
    
    var session: URLSession?
    
    
    // MARK: - Create Session Task(s)
    
    func task(request: URLRequest,
              status: @escaping DataTaskResponseCallback) -> URLSessionTask?
    {
        guard let session = self.session else
        { return nil }
        
        let task: URLSessionDataTask = session.dataTask(with: request)
        { (data, response, error) in
            
            guard error == nil,
                let response = response as? HTTPURLResponse else
            {
                status(nil, ServiceError.unkown)
                return
            }
            
            let statusCode = response.statusCode
            let serviceError = ServiceError.status(statusCode)
            
            guard let contentType = response.allHeaderFields[HTTPKeys.contentType.rawValue] as? String,
                let data = data  else
            {
                status(nil, serviceError)
                return
            }
            
            let mediaType = ContentType.mediaType(from: contentType)
            guard mediaType != .unkown else
            {
                status(nil, ServiceError.unkownData)
                return
            }
            
            status(TaskData(data: data, type: mediaType), serviceError)
        
        }
        return task
    }
}


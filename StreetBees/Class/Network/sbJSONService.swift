//
//  sbJSONService.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum JSONServiceError: Error
{
    case unkown
    case failed
    case badData
}

typealias JSONServiceResponseCallback = (JSONObject?, Error?) -> Void

class JSONService: DataService
{
    func resource(_ request: URLRequest,
                  completion: @escaping JSONServiceResponseCallback)
    { 
        let serialise: DataTaskResponseCallback =
        { (taskData, error) in
            
            guard let taskData = taskData,
                taskData.type == .applicationJson,
                let json = try? JSONSerialization.object(with: taskData.data) else
            {
                completion(nil, JSONServiceError.badData)
                return
            }
            completion(json, nil)
        }
        
        guard let task = self.task(request: request, status: serialise) else
        {
            completion(nil, JSONServiceError.unkown)
            return
        }
        task.resume()
    }
}


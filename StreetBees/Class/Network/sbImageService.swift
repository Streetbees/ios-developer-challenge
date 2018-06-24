//
//  sbImageService.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


enum ImageServiceError: Error
{
    case unkown
    case failed
    case badData
}

typealias ImageServiceResponseCallback = (UIImage?, Error?) -> Void

class ImageService: DataService
{
    func resource(_ request: URLRequest,
                  completion: @escaping ImageServiceResponseCallback)
    {
        let serialise: DataTaskResponseCallback =
        { (taskData, error) in
            
            guard let taskData = taskData,
                taskData.type == .imageJpeg,
                let data = taskData.data else
            {
                completion(nil, ImageServiceError.badData)
                return
            }
            completion(UIImage(data: data), nil)
        }
        
        guard let task = self.task(request: request, status: serialise) else
        {
            completion(nil, ImageServiceError.unkown)
            return
        }
        task.resume()
    }
}


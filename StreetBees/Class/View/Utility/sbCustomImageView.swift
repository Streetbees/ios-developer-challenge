//
//  sbCustomImageView.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class CustomImageView: UIImageView
{
    // MARK: - Hidden Property(s)
    
    fileprivate var task: URLSessionDataTask?
    
    
    // MARK: - Requesting an Image
    
    func setImage(_ url: URL?, placeholder: UIImage?)
    {
        self.image = placeholder
        
        self.task?.cancel()
        self.task = nil
        
        guard let url = url else
        { return }
        
        let request = URLRequest(url: url)
        if let cached = URLSession.shared.configuration.urlCache?.cachedResponse(for: request)
        {
            DispatchQueue.main.async
            { self.image = UIImage(data: cached.data) }
            return
        }
        
        self.task = URLSession.shared.dataTask(with: request)
        { [unowned self] (data, response, error) in
            
            guard error == nil,
                let data = data else
            { return }
            
            DispatchQueue.main.async
            { self.image = UIImage(data: data) }
        }
        self.task?.resume()
    }
}


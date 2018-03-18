//
//  UIImageView+AsynchronousImage.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 18/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func set(assynchronouslyFrom urlString: String, at index: Int) {
        
        if let image = ImageCacher.shared.image(for: urlString) {
            self.image = image
        } else {
            
            RequestManager.shared.get(imageWith: urlString, for: index) { [weak self] (success, imageData, error, i) in
                
                if index != i {
                    return
                }
                
                if success == true, let imageData = imageData {
                    
                    DispatchQueue.main.async {
                        
                        guard let image = UIImage(data: imageData) else { return }
                        
                        ImageCacher.shared.add(image, for: urlString)
                        
                        self?.image = image
                        
                    }
                }
            }   }
    }
}

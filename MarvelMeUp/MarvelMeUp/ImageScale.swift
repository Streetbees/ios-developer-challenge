//
//  ImageScale.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/26/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func scale(toWidth width: CGFloat) -> UIImage {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(width, newHeight))
        self.drawInRect(CGRectMake(0, 0, width, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

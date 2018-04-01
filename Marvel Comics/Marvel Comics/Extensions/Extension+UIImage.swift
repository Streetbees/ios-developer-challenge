//
//  Extension+UIImage.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import UIKit

extension UIImage {
  var makeImageWithRoundedCorners: UIImage {
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
    UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
    UIBezierPath(roundedRect: rect, cornerRadius: 5).addClip()
    self.draw(in: rect)
    return UIGraphicsGetImageFromCurrentImageContext()!
  }
}

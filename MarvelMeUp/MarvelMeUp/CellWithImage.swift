//
//  CellWithImage.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/24/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol CellWithImage {

    var cellImageView: UIImageView! { get set }
    var imageUrl: NSURL! { get set }
    
}
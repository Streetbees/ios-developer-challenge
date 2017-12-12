//
//  ComicCollectionViewCell.swift
//  Marvel
//
//  Created by Ollie Stowell on 11/12/2017.
//  Copyright © 2017 Stowell. All rights reserved.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var activity: UIActivityIndicatorView!
	
	var comic: ComicObject?
}

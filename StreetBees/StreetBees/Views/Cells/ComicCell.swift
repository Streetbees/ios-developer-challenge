
//
//  ComicCellCollectionViewCell.swift
//  StreetBees
//
//  Created by Richard Willis on 27/08/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

class ComicCell: UICollectionViewCell, CellProtocol {
	@IBOutlet weak var image: UIImageView!
	
    func populate<T>(with data: T?) {
		guard let strongImage = data as? UIImage else { return }
		image.image = strongImage
	}
}

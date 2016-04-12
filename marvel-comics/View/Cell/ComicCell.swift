//
//  ComicCell.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 12/04/2016.
//
//

import UIKit
import SwiftKeepLayout

class ComicCell: UICollectionViewCell {
	static let width = CGFloat((UIScreen.mainScreen().bounds.width - (COMICS_SPACING * 4)) / 3)
	static let height = CGFloat(ComicCell.width * 382 / 244)
	
	let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: CGRectMake(0, 0, ComicCell.width, ComicCell.height))
		
		contentView.backgroundColor = UIColor.grayColor()
		
		contentView.addSubview(imageView)
		imageView.keepInsets.vEqual = 0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

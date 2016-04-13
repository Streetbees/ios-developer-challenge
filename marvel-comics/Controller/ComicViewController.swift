//
//  ComicViewController.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 13/04/2016.
//
//

import UIKit
import SwiftKeepLayout
import Kingfisher

class ComicViewController: SharedViewController {
	// Models
	let comic: Comic
	
	// Views
	let scrollView = UIScrollView()
	let contentView = UIView()
	
	let comicImageView = UIImageView()
	let titleLabel = UILabel()
	let descriptionLabel = UILabel()
	
	init(comic: Comic) {
		self.comic = comic
		
		super.init()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "CameraIcon"), style: .Plain, target: self, action: #selector(ComicViewController.cameraButtonAction))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: LAYOUT
extension ComicViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = comic.title
		
		view.backgroundColor = UIColor(white: 0.8, alpha: 1)
		
		// Scroll View
		view.addSubview(scrollView)
		scrollView.keepInsets.vEqual = 0
		
		scrollView.addSubview(contentView)
		contentView.keepInsets.vEqual = 0
		contentView.keepWidthTo(scrollView).vEqual = 1
		
		// Content
		comicImageView.contentMode = .ScaleAspectFit
		comicImageView.kf_setImageWithURL(comic.thumbnailUrl!)
		contentView.addSubview(comicImageView)
		comicImageView.keepHorizontalInsets.vEqual = 10
		comicImageView.keepTopInset.vEqual = 8
		comicImageView.keepAspectRatio.vEqual = 244.0 / 382.0
		
		let whiteContainer = UIView()
		whiteContainer.backgroundColor = UIColor.whiteColor()
		contentView.addSubview(whiteContainer)
		whiteContainer.keepTopOffsetTo(comicImageView).vEqual = 0
		whiteContainer.keepHorizontalInsets.vEqual = 0
		whiteContainer.keepBottomInset.vEqual = 0
		
		titleLabel.text = comic.title
		titleLabel.numberOfLines = 1
		titleLabel.font = UIFont.boldSystemFontOfSize(14)
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
		whiteContainer.addSubview(titleLabel)
		titleLabel.keepTopInset.vEqual = 10
		titleLabel.keepHorizontalInsets.vEqual = 10
		
		descriptionLabel.text = comic.description
		descriptionLabel.numberOfLines = 0
		descriptionLabel.font = UIFont.systemFontOfSize(12)
		descriptionLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
		whiteContainer.addSubview(descriptionLabel)
		descriptionLabel.keepTopOffsetTo(titleLabel).vEqual = 10
		descriptionLabel.keepHorizontalInsets.vEqual = 10
		descriptionLabel.keepBottomInset.vEqual = 10
	}
}

// MARK: ACTION
extension ComicViewController {
	func cameraButtonAction() {
		
	}
}

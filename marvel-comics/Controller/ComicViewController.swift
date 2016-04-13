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
import BSImagePicker
import Photos

class ComicViewController: SharedViewController {
	// Models
	let comic: Comic
	
	// Views
	let scrollView = UIScrollView()
	let contentView = UIView()
	
	let comicImageView = UIImageView()
	let titleLabel = UILabel()
	let descriptionLabel = UILabel()
	
	// Controllers
	lazy var imagePickerController = BSImagePickerViewController()
	
	init(comic: Comic) {
		self.comic = comic
		
		super.init()
		
		navigationItem.hidesBackButton = true
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackIcon"), style: .Plain, target: self, action: #selector(UIViewController.backButtonAction))
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
		comicImageView.clipsToBounds = true
		comicImageView.contentMode = comic.customThumbnail == nil ? .ScaleAspectFit : .ScaleAspectFill
		comicImageView.kf_setImageWithURL(comic.customThumbnail ?? comic.thumbnailUrl!)
		contentView.addSubview(comicImageView)
		comicImageView.keepHorizontalInsets.vEqual = 10
		comicImageView.keepTopInset.vEqual = 8
		comicImageView.keepAspectRatio.vEqual = 244.0 / 382.0
		
		let whiteContainer = UIView()
		whiteContainer.backgroundColor = UIColor.whiteColor()
		contentView.addSubview(whiteContainer)
		whiteContainer.keepTopOffsetTo(comicImageView).vEqual = 10
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
	
	override func viewWillAppear(animated: Bool) { // This is for when we go back from the image picker
		super.viewWillAppear(animated)
		UIApplication.sharedApplication().statusBarStyle = .LightContent
	}
}

// MARK: ACTION
extension ComicViewController {
	func cameraButtonAction() {
		imagePickerController.maxNumberOfSelections = 1
		imagePickerController.takePhotos = true
		
		bs_presentImagePickerController(imagePickerController, animated: true, select: { (asset) in
			
			}, deselect: { (asset) in
				
			}, cancel: { (assets: [PHAsset]) in
				
			}, finish: { (assets: [PHAsset]) in
				PHImageManager.defaultManager().requestImageDataForAsset(assets.first!, options: PHImageRequestOptions(), resultHandler: { (imagedata, dataUTI, orientation, info) in
					if info!.keys.contains(NSString(string: "PHImageFileURLKey")) {
						if let path = info![NSString(string: "PHImageFileURLKey")] as? NSURL {
							print("Path: \(path)")
							
							self.comic.customThumbnail = path
							self.comicImageView.contentMode = .ScaleAspectFill
							self.comicImageView.kf_setImageWithURL(self.comic.customThumbnail!)
						}
					}
				})
		}) {
			UIApplication.sharedApplication().statusBarStyle = .Default
				
		}
	}
}

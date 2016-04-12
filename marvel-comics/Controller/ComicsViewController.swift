//
//  ComicsViewController.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 12/04/2016.
//
//

import UIKit
import Kingfisher

class ComicsViewController: UICollectionViewController {
	static let cellIdentifier = "comicCell"
	
	var comics = [Comic]()
	
	// MARK: INIT
	init() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.itemSize = CGSizeMake(ComicCell.width, ComicCell.height)
		flowLayout.minimumInteritemSpacing = 3
		flowLayout.minimumLineSpacing = 3
		
		super.init(collectionViewLayout: flowLayout)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComicsViewController.comicsDidUpdate), name: NOTIFICATION_COMICS_DID_UPDATE, object: Session.instance)
		
		Session.instance.requestComics()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: LAYOUT
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Marvel Comics"
		
		view.backgroundColor = UIColor(white: 0.8, alpha: 1)
		
		collectionView!.backgroundColor = UIColor(white: 0.9, alpha: 1)
		collectionView!.contentInset = UIEdgeInsetsMake(COMICS_SPACING, COMICS_SPACING, COMICS_SPACING, COMICS_SPACING)
		collectionView!.registerClass(ComicCell.self, forCellWithReuseIdentifier: ComicsViewController.cellIdentifier)
	}
}

// MARK: OBSERVERS
extension ComicsViewController {
	func comicsDidUpdate() {
		comics = Session.instance.comics
		collectionView?.reloadData()
	}
}

// MARK: COLLECTION
extension ComicsViewController {
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return comics.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ComicsViewController.cellIdentifier, forIndexPath: indexPath) as! ComicCell
		let comic = comics[indexPath.row]
		
		if comic.thumbnailUrl != nil {
			cell.imageView.kf_setImageWithURL(comic.thumbnailUrl!, placeholderImage: nil, optionsInfo: [
				.Transition(ImageTransition.FlipFromLeft(0.4))
				])
		}
		
		return cell
	}
}

extension ComicsViewController {
	
//	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//		
//		let width = view.bounds.size.width / 3
//		return CGSizeMake(width, width * 1.3)
//	}
//	
//	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//		return 0
//	}
//	
//	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//		return 0
//	}
//	
//	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//		let comic = comics[indexPath.row]
//		let marvelThumbnail = ImagesCache.instance.marvelCache[comic.id!]
//		let dropboxThumbnail = ImagesCache.instance.dropboxCache[comic.id!]
//		
//		let detailsScreen = ComicDetailsViewController(comic: comic, marvelThumbnail: marvelThumbnail, dropboxThumbnail: dropboxThumbnail)
//		navigationController?.pushViewController(detailsScreen, animated: true)
//	}
//	
	override func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y >= scrollView.contentSize.height - (scrollView.frame.size.height * 2) {
			Session.instance.requestComics()
		}
	}
}
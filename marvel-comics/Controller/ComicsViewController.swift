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
		flowLayout.minimumInteritemSpacing = COMICS_SPACING
		flowLayout.minimumLineSpacing = COMICS_SPACING
		
		super.init(collectionViewLayout: flowLayout)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComicsViewController.comicsDidUpdate), name: NOTIFICATION_COMICS_DID_UPDATE, object: Session.instance)
		
		Session.instance.requestComics()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: LAYOUT
extension ComicsViewController {
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
		
		if comic.customThumbnail != nil || comic.thumbnailUrl != nil {
			cell.imageView.kf_setImageWithURL(comic.customThumbnail ?? comic.thumbnailUrl!, placeholderImage: nil, optionsInfo: [
				.Transition(ImageTransition.FlipFromLeft(0.4))
				])
		}
		
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let comic = comics[indexPath.row]
		
		navigationController?.pushViewController(ComicViewController(comic: comic), animated: true)
	}
}

// MARK: SCROLL
extension ComicsViewController {
	override func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y >= scrollView.contentSize.height - (scrollView.frame.size.height * 2) {
			Session.instance.requestComics()
		}
	}
}
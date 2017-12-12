//
//  HomeViewController.swift
//  Marvel
//
//  Created by Ollie Stowell on 11/12/2017.
//  Copyright © 2017 Stowell. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	@IBOutlet var collectionView: UICollectionView!
	
	var comics : Results<ComicObject>?
	var comicNotification: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

		comics = RealmManager.shared.fetchComics()
		comicNotification = comics!.observe { [weak self] (changes: RealmCollectionChange) in
			guard let collectionView = self?.collectionView else { return }
			switch changes {
			case .initial:
				collectionView.reloadData()
			case .update(_, let deletions, let insertions, let modifications):
				
				collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0)}))
				collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
				collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
				
			case .error(let error):
				fatalError("\(error)")
			}
		}
		
		//TODO: only needs fetching once, then on user initiation
		DataManager.shared.fetchComics()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Collection View
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		if comics == nil {
			return 0
		} else {
			print("comics.count: \(comics!.count)")
			return comics!.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let comic = comics![indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell",
													  for: indexPath) as! ComicCollectionViewCell
		cell.layer.borderColor = UIColor.white.cgColor
		cell.layer.borderWidth = 2.0
		cell.comic = comic
		if comic.thumbnailData != nil {
			cell.imageView.image = UIImage(data: comic.thumbnailData!)
			cell.activity.stopAnimating()
		} else {
			cell.imageView.image = #imageLiteral(resourceName: "placeholder")
		}
		return cell
	}
	
    // MARK: - Navigation
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowComic" {
			let viewController = segue.destination as! ComicDetailViewController
			let cell = sender as! ComicCollectionViewCell
			
			viewController.comic = cell.comic
		}
    }
}


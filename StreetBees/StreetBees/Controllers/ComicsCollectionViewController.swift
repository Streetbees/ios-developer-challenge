//
//  ViewController.swift
//  StreetBees
//
//  Created by Richard Willis on 27/08/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

class ComicsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	let
	viewModel: ComicsCollectionViewModel,
	api: ApiService
	
	required init?(coder aDecoder: NSCoder) {
		api = ApiService()
		viewModel = ComicsCollectionViewModel(api)
		super.init(coder: aDecoder)
		viewModel.binder = {
			DispatchQueue.main.async { [weak self] in
				self?.collectionView?.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let comicCell = Consts.comicCell
		self.collectionView?.register(UINib(nibName: comicCell, bundle: nil), forCellWithReuseIdentifier: comicCell)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.comicCell, for: indexPath)
		guard
			let comicCell = cell as? ComicCell,
			let imageData = viewModel.getImageDataFor(indexPath)
			else { return cell }
		comicCell.populate(with: UIImage(data: imageData))
		return comicCell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: Consts.modalSegue, sender: indexPath)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath) -> CGSize {
		let
		screenSize: CGRect = UIScreen.main.bounds,
		smallestDimension = screenSize.width < screenSize.height ? screenSize.width : screenSize.height,
		oneThird = smallestDimension / 3
		return CGSize(width: oneThird * 0.75, height: oneThird)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.countComics
	}

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			let indexPath = sender as? IndexPath,
			let comicModal = segue.destination as? ComicDetailViewController,
			let imageData = viewModel.getImageDataFor(IndexPath(item: indexPath.item, section: 0))
			else { return }
		comicModal.image = UIImage(data: imageData)
	}
}

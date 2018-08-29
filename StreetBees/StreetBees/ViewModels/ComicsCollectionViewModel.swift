//
//  ComicsCollectionViewModel.swift
//  StreetBees
//
//  Created by Richard Willis on 27/08/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension ComicsCollectionViewModel {
	var countComics: Int {
		return imageIndices.count
	}
	
	func getImageDataFor(_ indexPath: IndexPath) -> Data? {
		guard let index = imageIndices[indexPath.row] else { return nil }
		return imagesData[imageUrls[index]]
	}
	
	fileprivate func getThumbnails() {
		let url = "\(comicsUrl)\(urlSuffix)"
		api.call(url, method: ApiMethods.GET) { [weak self] (result: JsonChild?) in
			guard
				let strongSelf = self,
				let results = strongSelf.getResults(from: result)
				else { return }
			for i in 0..<results.count {
				guard let thumbUrl = strongSelf.getImageUrl(from: results[i][Consts.thumbnail] as? JsonChild) else { return }
				if strongSelf.imageUrls.index(of: thumbUrl) == nil {
					strongSelf.imageUrls.append(thumbUrl)
					strongSelf.api.call(thumbUrl, method: ApiMethods.GET) { (imageData: Data?) in
						guard let strongImageData = imageData else { return }
						strongSelf.imagesData[thumbUrl] = strongImageData
						if strongSelf.imagesData.count == strongSelf.imageUrls.count {
							strongSelf.binder?()
						}
					}
				}
				strongSelf.imageIndices[i] = strongSelf.imageUrls.index(of: thumbUrl)
			}
			strongSelf.binder?()
		}
	}
}

class ComicsCollectionViewModel: MarvelViewModelProtocol {
	var binder: (() -> ())?
	
	fileprivate let
	api: ApiService,
	comicsUrl = "https://gateway.marvel.com:443/v1/public/comics"
	
	fileprivate var
	imageIndices: [Int: Int],
	imageUrls: [String],
	imagesData: [String: Data]
	
	init(_ api: ApiService) {
		self.api = api
		self.imageIndices = [:]
		self.imageUrls = []
		self.imagesData = [:]
		getThumbnails()
	}
}

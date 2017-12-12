//
//  DataManager.swift
//  Marvel
//
//  Created by Ollie Stowell on 11/12/2017.
//  Copyright © 2017 Stowell. All rights reserved.
//

import UIKit

///Manager for the data from Marvel
class DataManager: NSObject {
	///The static reference to the DataManager.
	static let shared = DataManager()
	
	internal let publicKey : String = "d018c92628e246a9c83204d9cd49e89b"
	internal let privateKey : String = "d23b43e0c98157bf7117c45e78ea5f77ad6d1321"
	internal let marvel : String = "http://gateway.marvel.com/v1/public/"
	
	public var comics: [ComicObject] = []
	
	var offsetCount = 0
	var total = 0
	
	/**
	Generates the required stamps, keys & hash for Marvel
	- Returns: The generated string.
	*/
	internal func generateHash() -> String {
		let time = Date()
		let formatter = DateFormatter()
		formatter.calendar = Calendar.current
		formatter.dateFormat = "ddMMYY"
		let timeStamp = formatter.string(from: time)
		let hashData = mD5(string: timeStamp + privateKey + publicKey)
		let hash = hashData.map { String(format: "%02hhx", $0) }.joined()
		print(hash)
		
		let hashString = "ts=" + timeStamp + "&apikey=" + publicKey + "&hash=" + hash
		print("hashString: \(hashString)")
		
		return hashString
	}
	
	/**
	Generates the md5 hash from the required parts.
	- Returns: The generated data.
	*/
	internal func mD5(string: String) -> Data {
		var messageData = string.data(using: .utf8)
		var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
		
		_ = digestData.withUnsafeMutableBytes { digestBytes in
			messageData!.withUnsafeBytes { messageBytes in
				CC_MD5(messageBytes, CC_LONG(messageData!.count), digestBytes)
			}
		}
		
		return digestData
	}
	
	/**
	Compiles all the appropriate parts to make the url string.
	- Returns: a string to generate the url from.
	*/
	internal func generateURLString(resource: String) -> String {
		if total == 0 {
			return marvel + resource + "?" + generateHash()
		} else {
			return marvel + resource + "?offset=\(offsetCount)&" + generateHash()
		}
	}
	
	/**
	Loops the fetchComics (until I find a better solution) until all comics are parsed.
	*/
	//FIXME: should page while user scrolls - there is a large amount of data.
	internal func fetchMore() {
		if offsetCount < total {
			self.fetchComics()
		}
	}
	
	/**
	Checks if the current `Object` exists, then adds or updates as required.
	- Parameter object: The `ComicObject` to save.
	*/
	internal func saveObject(object: ComicObject) {
		print("object: \(object)")
		var update = false
		if RealmManager.shared.checkIfObjectExists(ident: object.ident) {
			update = true
		}
		
		_ = RealmManager.shared.writeObject(object: object,
											update: update)
	}
	
	// MARK: - Public Functions
	
	/**
	Sends a request to the Marvel API, parses the data and adds relevant items to database.
	*/
	public func fetchComics() {
		let urlString = generateURLString(resource: "comics")
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		
		guard let url = URL(string: urlString) else {
			return
		}
		let task = session.dataTask(with: url,
									completionHandler:
			{ (data, response, error) in
				guard let data = data else {
					return
				}
				do {
					guard let json = try JSONSerialization.jsonObject(with: data,
																	  options: .mutableContainers) as? [String:Any] else {
																		return
					}
					guard let wholeData = json["data"] as? [String : Any] else {
						return
					}
					
					self.total = wholeData["total"] as! Int
					guard let comicData = wholeData["results"] as? [[String : Any]] else {
						return
					}
					self.offsetCount += comicData.count
					
					print("offset: \(self.offsetCount) - total: \(self.total)")
					for comic in comicData {
						//TODO: fetch characters
						//TODO: tidy up this mess
						//FIXME: slow loading due to early image fetching
						//Should be added to a seperate thread and update the object then
						
						let ident = comic["id"] as? Int
						if ident == nil {
							continue
						}
						
						let title = comic["title"] as? String
						let idString = "\(ident!)"
						let comicDesc = comic["description"] as? String
						let imageArray = comic["images"] as? [[String: String]]
						
						let object = ComicObject()
						object.ident = idString
						object.title = title ?? "No title"
						object.comicDesc = comicDesc ?? "No description"
						
						if imageArray!.count > 0 {
							let images = imageArray?[0]
							
							let thumbnailPath = images?["path"]
							let thumbnailEx = images?["extension"]
							object.imageURLString = "\(thumbnailPath!)"
							
							guard let thumbURL = URL(string: object.imageURLString! + "/portrait_uncanny." + "\(thumbnailEx!)") else {
								self.saveObject(object: object)
								continue
							}
							guard let portraitURL = URL(string: object.imageURLString! + "/detail." + "\(thumbnailEx!)") else {
								self.saveObject(object: object)
								continue
							}
							
							do {
								let thumbData = try Data(contentsOf: thumbURL)
								object.thumbnailData = thumbData
								let portraitData = try Data(contentsOf: portraitURL)
								object.portraitData = portraitData
								
								self.saveObject(object: object)
							} catch {
								self.saveObject(object: object)
								continue
							}
						}
					}
				} catch {
					self.fetchMore()
					return
				}
				self.fetchMore()
		})
		task.resume()
	}
}

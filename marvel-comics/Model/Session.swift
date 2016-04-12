//
//  Session.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import Foundation
import Alamofire
import CryptoSwift

class Session {
	static let instance = Session()
	
	private(set) var comics = [Comic]()
	
	private init() { // private ensure singleton pattern
		
	}
	
	func requestComics() {
		Request(stringUrl: API_COMICS_URL, parameters: [
			"offset": COMIC_BATCH_LIMIT,
			"limit": COMIC_BATCH_LIMIT,
			"orderBy": "-onsaleDate"
		]) { (result: [String : AnyObject]) -> (Void) in
			guard let comicsJson = result["results"] as? [[String: AnyObject]]
				else { return }
			
			self.comics = comicsJson.map{ Comic(dictionary: $0) }
			
			for comic in self.comics {
				print( comic.title ?? "No title" )
			}
		}?.send()
	}
}

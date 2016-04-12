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

let NOTIFICATION_COMICS_DID_UPDATE = "NOTIFICATION_COMICS_DID_UPDATE"

class Session {
	static let instance = Session()
	
	private(set) var comics = [Comic]()
	private(set) var comicsState: RequestState = (false, false)
	
	private init() { // private ensure singleton pattern
		
	}
	
	func requestComics() {
		if comicsState.loading { return }
		
		Request(stringUrl: API_COMICS_URL, parameters: [
			"offset": comics.count,
			"limit": COMIC_BATCH_LIMIT,
			"orderBy": "-onsaleDate"
		]) { (result: [String : AnyObject]) -> (Void) in
			
			guard let comicsJson = result["results"] as? [[String: AnyObject]]
				else { return }
			
			Mana.dispatchAsync {
				self.comics += comicsJson.map{ Comic(dictionary: $0) }
				
				Mana.dispatchMainThread {
					self.comicsState = (false, true)
					NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_COMICS_DID_UPDATE, object: self)
				}
			}
		}?.send()
		self.comicsState = (true, self.comicsState.loaded)
	}
}

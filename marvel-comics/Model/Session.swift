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
		func parameters() -> [String: AnyObject] {
			let timestamp = String(NSDate().timeIntervalSince1970 * 1000)
			let hash = "\(timestamp)\(API_PRIVATE_KEY)\(API_PUBLIC_KEY)".md5()
			return [
				"apikey": API_PUBLIC_KEY,
				"ts": timestamp,
				"hash": hash
			]
		}
		
		Alamofire.request(.GET, API_COMICS_URL, parameters: parameters()).responseJSON { response in
			guard let json = response.result.value as? [String: AnyObject],
				let data = json["data"] as? [String: AnyObject]
				else { return }
			
			print(json)
			
			guard let comicsJson = data["results"] as? [[String: AnyObject]]
				else { return }
			
			self.comics = comicsJson.map{ Comic(dictionary: $0) }
			
			for comic in self.comics {
				print( comic.title )
			}
		}
	}
}

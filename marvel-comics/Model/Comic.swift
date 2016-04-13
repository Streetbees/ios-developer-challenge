//
//  Comic.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import Foundation
import Argo
import Curry

class Comic {
	var id: Int?
	var title: String?
	var description: String?
	var updateDate: NSDate?
	var thumbnailPath: String?
	var thumbnailExtension: String?
	var thumbnailUrl: NSURL? {
		guard let path = thumbnailPath where !path.isEmpty,
			let ext = thumbnailExtension where !ext.isEmpty
			else { return nil }
		
		return NSURL(string: "\(path).\(ext)")
	}
	var customThumbnail: NSURL?
	
	init(dictionary: [String: AnyObject]) {
		self.id = dictionary["id"] as? Int
		self.title = dictionary["title"] as? String
		self.description = dictionary["description"] as? String
		
		if let modified = dictionary["modified"] as? String {
			self.updateDate = MARVEL_JSON_DATE_FORMATTER.dateFromString(modified)
		}
		
		if let thumbnail = dictionary["thumbnail"] as? [String: AnyObject] {
			self.thumbnailPath = thumbnail["path"] as? String
			self.thumbnailExtension = thumbnail["extension"] as? String
		}
	}
}

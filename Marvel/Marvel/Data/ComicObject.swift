//
//  ComicObject.swift
//  Marvel
//
//  Created by Ollie Stowell on 11/12/2017.
//  Copyright © 2017 Stowell. All rights reserved.
//

import UIKit
import RealmSwift

class ComicObject: Object {
	@objc dynamic var ident: String = ""
	@objc dynamic var title: String = ""
	@objc dynamic var comicDesc: String = ""
	
	@objc dynamic var imageURLString: String?
	@objc dynamic var thumbnailData: Data?
	@objc dynamic var portraitData: Data?
	
	override static func primaryKey() -> String {
		return "ident"
	}
}

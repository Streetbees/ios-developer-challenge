//
//  Comic.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import Foundation
import SwiftyDropbox

let NOTIFICATION_COMIC_IMAGE_DID_UPDATE = "NOTIFICATION_COMIC_IMAGE_DID_UPDATE"

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
	private var dropboxPath: String {
		return "/\(id!).png"
	}
	var cleanTemporaryFileURL: NSURL {
		do {
			try NSFileManager.defaultManager().removeItemAtURL(temporaryFileURL)
		} catch {}
		return temporaryFileURL
	}
	var temporaryFileURL: NSURL {
		return NSURL(fileURLWithPath: NSTemporaryDirectory() + self.dropboxPath)
	}
	var customThumbnail: NSURL? {
		didSet {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_COMIC_IMAGE_DID_UPDATE, object: self)
		}
	}
	
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
		
		checkForDropboxImage()
	}
}

// Dropbox
extension Comic {
	internal func checkForDropboxImage() {
		if Dropbox.authorizedClient != nil {
			Dropbox.authorizedClient!.files.getThumbnail(path: dropboxPath, size: .W640h480, destination: { (url: NSURL, response: NSHTTPURLResponse) -> NSURL in
				return self.cleanTemporaryFileURL
			}).response({ (files: ((Files.FileMetadata), NSURL)?, error: CallError<(Files.ThumbnailError)>?) in
				if files != nil {
					self.customThumbnail = self.temporaryFileURL
				}
			})
		}
	}
	
	internal func removeDropboxImage() {
		if customThumbnail != nil {
			customThumbnail = nil
		}
	}
	
	internal func deleteDropboxImage() {
		customThumbnail = nil
		if Dropbox.authorizedClient != nil {
			Dropbox.authorizedClient!.files.delete(path: dropboxPath)
		}
	}
	
	internal func saveDropboxImage() {
		if Dropbox.authorizedClient != nil && customThumbnail != nil {
			Dropbox.authorizedClient!.files.upload(path: dropboxPath, mode: .Overwrite, autorename: false, body: customThumbnail!).progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
				let value = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
				print(value)
			})
		}
	}
}

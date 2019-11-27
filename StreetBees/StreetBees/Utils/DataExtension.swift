//
//  DataExtension.swift
//  StreetBees
//
//  Created by Richard Willis on 28/08/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

// with help from Dmitry Isaev at https://stackoverflow.com/questions/21789770/determine-mime-type-from-nsdata#32765708
extension Data {
	enum mimeTypes: String {
		case BMP, GIF, JPG, OCT, PNG, RTF
	}
	
	var mimeType: Data.mimeTypes {
		var cb: UInt8 = 0
		copyBytes(to: &cb, count: 1)
		return Data.mimeTypeSignatures[cb] ?? mimeTypes.OCT
	}
	
	private static let mimeTypeSignatures: [UInt8: Data.mimeTypes] = [
		0x46: Data.mimeTypes.BMP,
		0x47: Data.mimeTypes.GIF,
		0x7B: Data.mimeTypes.RTF,
		0x89: Data.mimeTypes.PNG,
		0xFF: Data.mimeTypes.JPG
	]
}

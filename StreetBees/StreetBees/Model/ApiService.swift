//
//  FZ_SV_API.swift
//  Filzanzug
//
//  Created by Richard Willis on 19/10/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

enum ApiMethods: String { case GET, POST, DELETE }

typealias ApiClosure<T> = ((T?) -> Void)

extension ApiService {
	func call<T>(_ url: String, method: ApiMethods, closure: @escaping ApiClosure<T>) {
		guard
			ongoingCalls.index(of: url) == nil,
			let validUrl = URL(string: url)
			else { return }
		ongoingCalls.append(url)
		var request = URLRequest(url: validUrl)
		request.httpMethod = method.rawValue
		_ = URLSession.shared.dataTask( with: request ) { [weak self] data, response, error in
			guard let strongSelf = self else { return }
			guard error == nil else {
				print("todo ERROR to be handled here", url)
				return
			}
			guard let strongData = data else {
				print( "todo NO DATA to be handled here" )
				return
			}
			// todo timer to cancel hanging calls can be cancelled?
			if let callIndex = strongSelf.ongoingCalls.index(of: url) {
				strongSelf.ongoingCalls.remove(at: callIndex)
			}
			do {
				switch strongData.mimeType {
				case Data.mimeTypes.RTF:		strongSelf.castTo(richText: strongData, calling: closure)
				case Data.mimeTypes.BMP,
					 Data.mimeTypes.GIF,
					 Data.mimeTypes.JPG,
					 Data.mimeTypes.PNG:		strongSelf.castTo(image: strongData, calling: closure)
				default: ()
				}
			}
		}.resume()
	}
	
	fileprivate func castTo<T>(image data: Data, calling closure: ApiClosure<T>) {
		closure(data as? T)
	}
	
	fileprivate func castTo<T>(richText data: Data, calling closure: ApiClosure<T>) {
		do {
			if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JsonChild {
				closure(json[Consts.data] as? T)
			}
		} catch {
			closure(nil)
		}
	}
}

class ApiService {
	fileprivate var ongoingCalls: [String]
	
	required init() {
		ongoingCalls = []
	}
}

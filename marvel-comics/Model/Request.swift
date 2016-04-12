//
//  Request.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import Foundation

typealias RequestCompletion = ([String: AnyObject]) -> (Void)

class Request {
	let url: NSURL
	let parameters: [String: AnyObject]?
	let completion: RequestCompletion?
	
	init(url: NSURL, parameters: [String: AnyObject]? = nil, completion: RequestCompletion? = nil) {
		self.url = url
		self.parameters = Request.defaultParameters() + (parameters ?? [:])
		self.completion = completion
	}
	
	convenience init?(stringUrl: String, parameters: [String: AnyObject]? = nil, completion: RequestCompletion? = nil) {
		guard let url = NSURL(string: stringUrl)
			else {
				assert(false, "given url isn't right")
				return nil
		}
		
		self.init(url: url, parameters: parameters, completion: completion)
	}
	
	func send() {
		WebService.sendRequest(self)
	}
}

extension Request {
	class private func defaultParameters() -> [String: AnyObject] {
		let timestamp = String(NSDate().timeIntervalSince1970 * 1000)
		let hash = "\(timestamp)\(API_PRIVATE_KEY)\(API_PUBLIC_KEY)".md5()
		
		return [
			"apikey": API_PUBLIC_KEY,
			"ts": timestamp,
			"hash": hash
		]
	}
}
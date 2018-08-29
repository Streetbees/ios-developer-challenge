//
//  MarvelViewModelProtocol.swift
//  StreetBees
//
//  Created by Richard Willis on 28/08/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

typealias JsonChild = [String: Any]

extension MarvelViewModelProtocol {
	// having checked the following url, I feel fine hardcoding a private key for a test like this
	// https://stackoverflow.com/questions/14778429/secure-keys-in-ios-app-scenario-is-it-safe/14865695#14865695
	var urlSuffix: String {
		let
		timeStamp = 1, // todo proper time stamp later
		publicKey = "d92a623383ecb3df929069559c7ce2d3",
		privateKey = "3a3b69986d5ca080d0e352f41a0a9360a046ef67",
		md5Input = "\(timeStamp)\(privateKey)\(publicKey)"
		return "?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(md5Input.utf8.md5)"
	}
	
	func getImageUrl(from json: JsonChild?) -> String? {
		guard
			let path = json?["path"] as? String,
			let fileType = json?["extension"] as? String
			else { return nil }
		return "\(path).\(fileType)".replacingOccurrences(of: "http://", with: "https://")
	}
	
	func getResults(from json: JsonChild?) -> [JsonChild]? {
		guard let unwrappedJson = json else { return nil }
		return unwrappedJson["results"] as? [JsonChild]
	}
}

protocol MarvelViewModelProtocol {
	var binder: (() -> ())? { get set }
}

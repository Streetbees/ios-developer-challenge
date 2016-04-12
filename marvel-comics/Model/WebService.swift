//
//  WebService.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import Foundation
import Alamofire

class WebService {
	class func sendRequest(request: Request) {
		Alamofire.request(.GET, request.url, parameters: request.parameters).responseJSON { response in
			// Here we will manage all errors at higher level (like no network etc.)
			
			guard let json = response.result.value as? [String: AnyObject],
				let data = json["data"] as? [String: AnyObject]
				else { return }
			
			print(data)
			
			request.completion?(data)
		}
	}
}
//
//  Extensions.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import UIKit

// All extension except if they are too big then we create a specific file for it

func +<K, V> (left: [K : V], right: [K : V]) -> [K : V] {
	var new = [K : V]()
	for (k, v) in left { new[k] = v }
	for (k, v) in right { new[k] = v }
	return new
}

class Mana {
	class func random(from: Int, to: Int) -> Int {
		return Int(arc4random_uniform(UInt32(to - from))) + from
	}
	
	class func dispatchAfter(delay:Double, closure:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(delay * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), closure)
	}
	
	class func dispatchMainThread(closure:()->()) {
		dispatch_async(dispatch_get_main_queue(), closure)
	}
	
	class func dispatchAsync(closure:()->()) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure)
	}
	
	/// Use DISPATCH_QUEUE_PRIORITY_XXX
	class func dispatchAsync(priority: Int, closure:()->()) {
		dispatch_async(dispatch_get_global_queue(priority, 0), closure)
	}
}

extension UIViewController {
	public func backButtonAction() {
		navigationController?.popViewControllerAnimated(true)
	}
}
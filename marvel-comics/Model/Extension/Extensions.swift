//
//  Extensions.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import Foundation

// All extension except if they are too big then we create a specific file for it

func +<K, V> (left: [K : V], right: [K : V]) -> [K : V] {
	var new = [K : V]()
	for (k, v) in left { new[k] = v }
	for (k, v) in right { new[k] = v }
	return new
}
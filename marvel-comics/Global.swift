//
//  Global.swift
//  marvel-comics
//
//  Created by Tancrède Chazallet on 11/04/2016.
//
//

import Foundation

let API_BASE_URL = "https://gateway.marvel.com/"
let API_VERSION = "v1"
let API_PUBLIC_KEY = "009f400afdb6fe37c1320a79da419690"
let API_PRIVATE_KEY = "fbfc5ce40674c65f095247e425f46bdbb565e935"
let API_DEFAULT_URL = API_BASE_URL + API_VERSION + "/public/"
let API_COMICS_URL = API_DEFAULT_URL + "comics"

let MARVEL_JSON_DATE_FORMATTER: NSDateFormatter = {
	let dateFormatter = NSDateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
	dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
	return dateFormatter
}()

let COMIC_BATCH_LIMIT = 30
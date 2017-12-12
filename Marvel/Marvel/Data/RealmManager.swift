//
//  RealmManager.swift
//  Marvel
//
//  Created by Ollie Stowell on 12/12/2017.
//  Copyright © 2017 Stowell. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {
	static let shared =  RealmManager()
	//TODO: Documentation.
	
	// MARK: Internal Functions
	
	/**
	Creates a reference to the Realm Database.
	- Warning: Failing will render the app useless, should be a fatalError.
	*/
	internal func fetchRealm() -> Realm? {
		do {
			let realm = try Realm()
			return realm
		} catch {
			print("Failed to init realm.")
			return nil
		}
	}
	
	/**
	Writes or updates the object as required.
	- Parameters:
		- object: The `Object` to be written to the database.
		- update: A `Bool` value indicating if the object already exists in the database.
	- Returns: `true` if the write was successful or `false` if it failed.
	*/
	internal func writeObject(object: Object, update: Bool) -> Bool {
		guard let realm = self.fetchRealm() else {
			return false
		}
		
		realm.beginWrite()
		realm.add(object, update: update)
		do {
			try realm.commitWrite()
			return true
		} catch {
			return false
		}
	}
	
	// MARK: - Public Functions
	
	/**
	Fetches all the `ComicObject` objects from the database.
	- Returns: A `Results<ComicObject>` (A Realm custom object, like a read-only `Array`) containing all the objects.
	*/
	public func fetchComics() -> Results<ComicObject>? {
		guard let realm = self.fetchRealm() else {
			return nil
		}
		
		return realm.objects(ComicObject.self)
	}
	
	/**
	Checks if the ident is assigned to an object in the realm.
	*/
	public func checkIfObjectExists(ident: String) -> Bool {
		guard let realm = self.fetchRealm() else {
			return false
		}
		
		let object = realm.object(ofType: ComicObject.self,
								  forPrimaryKey: ident)
		
		if object == nil {
			return false
		} else {
			return true
		}
	}
}

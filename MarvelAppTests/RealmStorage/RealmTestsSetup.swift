//
//  RealmTestsSetup.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 28/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import RealmSwift
import Realm

struct RealmTestsSetup {
    func setInMemoryDatabase() -> Realm.Configuration {
        return Realm.Configuration.init(inMemoryIdentifier: "inMemoryTestDatabase")
    }
    
    func clearDatabase() {
        let realm = try! Realm(configuration: setInMemoryDatabase())
        try! realm.write {
            realm.deleteAll()
        }
    }
}

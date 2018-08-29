//
//  Repository.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol AbstractRepository {
    associatedtype T
    func fetchAll(sortDescriptors: [NSSortDescriptor]) -> [T]
    func fetch(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> [T]
    func save(entities: [T]) throws
}

final class Repository<T:RealmRepresentable>: AbstractRepository where T == T.RealmType.DomainType, T.RealmType: Object {

    private let configuration: Realm.Configuration

    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }

    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }

    func fetchAll(sortDescriptors: [NSSortDescriptor] = []) -> [T] {
        return realm.objects(T.RealmType.self)
            .sorted(by: sortDescriptors.map(SortDescriptor.init))
            .mapToDomain()
    }

    func fetch(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> [T] {

        return realm.objects(T.RealmType.self)
            .filter(predicate)
            .sorted(by: sortDescriptors.map(SortDescriptor.init))
            .mapToDomain()
    }

    func save(entities: [T]) throws {
        do {
            try realm.write {
                realm.add(entities.map { $0.asRealm() }, update: true)
            }
        } catch let error {
            throw error
        }
    }
}


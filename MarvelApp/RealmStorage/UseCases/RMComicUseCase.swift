//
//  ComicUseCase.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class RMComicUseCase<Repository>: ComicUseCase where Repository: AbstractRepository, Repository.T == Comic {

    private let repository: Repository
    
    var notificationToken: NotificationToken?
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func fetchComics(sortDescriptors: [NSSortDescriptor] = []) -> [Comic] {
        return repository.fetchAll(sortDescriptors: sortDescriptors)
    }

    func fetchComic(withId id: Int) -> Comic? {
        let predicate = NSPredicate(format: "id == %i", id)
        return repository.fetch(with: predicate, sortDescriptors: []).first
    }
    
    func fetchComic(withTitle title: String) -> [Comic] {
        let predicate = NSPredicate(format: "title CONTAINS %@", title)
        return repository.fetch(with: predicate, sortDescriptors: [])
    }
    
    func save(comics: [Comic]) throws {
        do {
            try repository.save(entities: comics)
        } catch let error {
            throw error
        }
    }
}

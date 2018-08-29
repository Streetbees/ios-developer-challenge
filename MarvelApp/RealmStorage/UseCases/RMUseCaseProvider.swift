//
//  RMUseCaseProvider.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 27/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class RMUseCaseProvider: UseCaseProvider {
    
    private let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.configuration = configuration
    }
    
    func makeComicUseCase() -> ComicUseCase {
        let repository = Repository<Comic>(configuration: configuration)
        return RMComicUseCase(repository: repository)
    }
}

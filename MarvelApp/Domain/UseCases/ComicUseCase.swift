//
//  ComicUseCase.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

protocol ComicUseCase {
    
    func fetchComics(sortDescriptors: [NSSortDescriptor]) -> [Comic]
    func fetchComic(withId id: Int) -> Comic?
    func fetchComic(withTitle id: String) -> [Comic]
    
    func save(comics:[Comic]) throws
}

extension ComicUseCase {
    
    func fetchComics(sortDescriptors: [NSSortDescriptor] = []) -> [Comic] {
        return fetchComics(sortDescriptors: sortDescriptors)
    }
}

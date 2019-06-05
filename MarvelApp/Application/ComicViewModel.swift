//
//  ComicViewModel.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

enum ComicError: Error {
    case noData
    case parsingError(message: String)
    case saveError(message: String)
}

final class ComicViewModel {

    private var service: MarvelService
    private var repository: ComicUseCase

    var isFetching: Bool = false
    
    init(service: MarvelService, repository: ComicUseCase) {
        self.service = service
        self.repository = repository
    }
    
    func getComics(offset: Int, completionHandler: @escaping (_ error: Error?) -> Void) {
        
        isFetching = true
        
        service.getComics(offset: offset) { data, error in
            
            self.isFetching = false
            
            guard error == nil else {
                completionHandler(error)
                return
            }
            
            guard let comicData = data else {
                completionHandler(ComicError.noData)
                return
            }
            
            let parsedData: PayloadWrapper<Comic>
            
            do {
                parsedData = try self.parse(comicData: comicData)
            } catch let error {
                completionHandler(ComicError.parsingError(message: error.localizedDescription))
                return
            }
            
            do {
                try self.save(comics: parsedData.data.results)
                completionHandler(nil)
            } catch let error {
                completionHandler(ComicError.saveError(message: error.localizedDescription))
            }
        }
    }
    
    func numberOfComics() -> Int {
        return repository.fetchComics().count
    }
    
    func comicAtIndex(index: Int) -> Comic? {
        
        if index > repository.fetchComics().count {
            return nil
        } else {
            return repository.fetchComics()[index]
        }
    }
    
    private func parse(comicData: Data) throws -> PayloadWrapper<Comic> {
        
        let comicParser = ComicParser(parser: JSONParser())
        do {
            return try comicParser.decode(data: comicData)
        } catch let error {
            throw error
        }
    }
    
    private func save(comics:[Comic]) throws {
        do {
            try repository.save(comics: comics)
        } catch let error {
            throw error
        }
    }
}


//





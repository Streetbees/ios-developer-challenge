//
//  MarvelDataServiceDelegate.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

// Contract between collection viewModel class and DataService class
protocol MarvelDataServiceDelegate {
    
    func didSucceedToFetchComics(withComicDataWrapper comicDataWrapper: ComicDataWrapper) -> Void
    func didFailToFetchComics(withError error: Error) -> Void
}

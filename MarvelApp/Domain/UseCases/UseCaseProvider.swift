//
//  UseCaseProvider.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

protocol UseCaseProvider {
    
    func makeComicUseCase() -> ComicUseCase
}

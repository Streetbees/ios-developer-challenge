//
//  ComicCellViewModel.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

protocol ComicCellPresentable {
  var imageURL: URL? { get }
}

struct ComicCellViewModel: ComicCellPresentable {
  
  let comic: MarvelComic
  
  var imageURL: URL? {
    return comic.thumbnail.getImageURL(.portraitFantastic)
  }
}

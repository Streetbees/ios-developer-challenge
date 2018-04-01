//
//  CharacterCellViewModel.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

protocol CharacterCellPresentable {
  var imageURL: URL? { get }
  var name: String { get }
}

struct CharacterCellViewModel: CharacterCellPresentable {
  
  let character: MarvelCharacter
  
  var imageURL: URL? {
    return character.thumbnail.getImageURL(.standardSmall)
  }
  
  var name: String {
    return character.name
  }
}

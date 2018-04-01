//
//  CharacterCellViewModelTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest

import XCTest
import Nimble

@testable import Marvel_Comics
class CharacterCellViewModelTests: XCTestCase {
  
  var characterCell: CharacterCellNode!
  
  func testComicCellSetup() {
    let character = MarvelCharacter(id: 123, name: "Hulk", thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/e/e0/4bac3ad5d17c7", fileExtension: "jpg"))
    
    let viewModel = CharacterCellViewModel(character: character)
    characterCell = CharacterCellNode(with: viewModel)
    
    let expectedURL = URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/e/e0/4bac3ad5d17c7/standard_small.jpg")
    
    expect(viewModel.imageURL).to(equal(expectedURL))
    expect(viewModel.name).to(equal("Hulk"))
    
  }
}

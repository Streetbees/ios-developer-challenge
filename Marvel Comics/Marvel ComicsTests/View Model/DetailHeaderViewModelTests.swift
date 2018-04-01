//
//  DetailHeaderViewModelTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble

@testable import Marvel_Comics
class DetailHeaderViewModelTests: XCTestCase {
    
  var headerNode: DetailHeaderNode!
  
  func testComicCellSetup() {
    let comic = MarvelComic(id: 123, title: "Daredevil", description: "Test Description", thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/e/e0/4bac3ad5d17c7", fileExtension: "jpg"))
    
    let viewModel = DetailHeaderViewModel(comic: comic)
    headerNode = DetailHeaderNode(with: viewModel)
    
    let expectedURL = URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/e/e0/4bac3ad5d17c7/standard_fantastic.jpg")
    
    expect(viewModel.imageURL).to(equal(expectedURL))
    expect(viewModel.title).to(equal("Daredevil"))
    expect(viewModel.description).to(equal("Test Description"))
  }
}

//
//  DetailViewController.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import AsyncDisplayKit

class DetailViewController: ASViewController<ASScrollNode>, ActivityIndicatorPresenter {
  
  private let apiService: APIService
  private let comic: MarvelComic
  
  private var scrollNode: DetailViewScrollNode!
  
  init(with comic: MarvelComic, apiService: APIService) {
    let scrollNode = DetailViewScrollNode(with: comic)
    self.comic = comic
    self.apiService = apiService
    
    super.init(node: scrollNode)
    
    self.scrollNode = scrollNode
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchCharacters()
  }
  
  func fetchCharacters() {
    self.showActivityIndicator()
    apiService.requestCharacters(comicId: comic.id, { (response) in
      self.scrollNode.characters = response.data.results
      self.hideActivityIndicator()
    }) { (error) in
      self.hideActivityIndicator()
      // TODO: Handle Errors
      print(error)
    }
  }
}

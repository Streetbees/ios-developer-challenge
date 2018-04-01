//
//  HomeViewController.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HomeViewController: ASViewController<ASDisplayNode>, ActivityIndicatorPresenter {
  
  private let apiService: APIService
  private var navigator: MarvelNavigator!
  
  private var collectionNode: ASCollectionNode!
  
  private var offset = 0
  
  var comics: [MarvelComic] = []
  
  init(apiService: APIService) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionNode = ASCollectionNode(collectionViewLayout: layout)
    
    self.apiService = apiService
    super.init(node: collectionNode)
    
    self.collectionNode = collectionNode
    self.collectionNode.delegate = self
    self.collectionNode.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavBar()
  }
  
  private func setupNavBar() {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.showActivityIndicator()
    self.navigator = MarvelNavigator(navigationController: navigationController, apiService: apiService)
    self.view.backgroundColor = UIColor.white
  }
}

extension HomeViewController: ASCollectionDelegate {
  func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
    let collectionViewSize = collectionNode.frame.width
    return ASSizeRange(min: CGSize.zero, max: CGSize(width: collectionViewSize / 3, height: collectionViewSize / 2))
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
    navigator.showDetailPage(dataSource: comics, index: indexPath.row)
  }
  
  func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
    return true
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
    apiService.requestComics(offset: offset, { [weak self] (response) in
      self?.insertNewComics(response.data.results)
      self?.hideActivityIndicator()
      context.completeBatchFetching(true)
    }) { (error) in
      self.hideActivityIndicator()
      // TODO: Handle Errors
      print(error)
    }
  }
  
  private func insertNewComics(_ newComics: [MarvelComic]) {
    var indexPaths = [IndexPath]()
    
    let newTotalNumberOfComics = comics.count + newComics.count
    
    for comic in comics.count ..< newTotalNumberOfComics {
      let indexPath = IndexPath(item: comic, section: 0)
      indexPaths.append(indexPath)
    }
    
    comics.append(contentsOf: newComics)
    
    if let collectionNode = node as? ASCollectionNode {
      collectionNode.performBatch(animated: true, updates: {
        collectionNode.insertItems(at: indexPaths)
      }, completion: { [weak self] (finished) in
        if finished {
          self?.offset += 50
        }
      })
    }
  }
}

extension HomeViewController: ASCollectionDataSource {
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return 1
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return comics.count
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    guard comics.count > indexPath.row else { return { ASCellNode() } }
    let comic = comics[indexPath.row]
    
    let cellNodeBlock = { () -> ASCellNode in
      let viewModel = ComicCellViewModel(comic: comic)
      return ComicCellNode(with: viewModel)
    }
    return cellNodeBlock
  }
}


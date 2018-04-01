//
//  DetailViewScrollNode.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class DetailViewScrollNode: ASScrollNode {
  
  private lazy var tableNode: ASTableNode = {
    let tableNode = ASTableNode()
    tableNode.delegate = self
    tableNode.dataSource = self
    tableNode.view.separatorStyle = .none
    tableNode.view.allowsSelection = false
    tableNode.view.tableFooterView = UIView(frame: .zero)
    tableNode.style.flexGrow = 1.0
    return tableNode
  }()
  
  private var detailHeader: DetailHeaderNode!
  
  var characters: [MarvelCharacter] = [] {
    didSet {
      DispatchQueue.main.async {
        self.tableNode.reloadData()
      }
    }
  }
  
  init(with comic: MarvelComic) {
    super.init()
    setupUI(comic)
  }
  
  private func setupUI(_ comic: MarvelComic) {
    self.automaticallyManagesSubnodes = true
    self.automaticallyManagesContentSize = true
    let viewModel = DetailHeaderViewModel(comic: comic)
    detailHeader = DetailHeaderNode(with: viewModel)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    let stack = ASStackLayoutSpec.vertical()
    stack.alignItems = .stretch
    stack.justifyContent = .spaceBetween
    stack.spacing = 5
    stack.children = [detailHeader, tableNode]
    stack.style.flexShrink = 1.0
    return stack
  }
}

extension DetailViewScrollNode: ASTableDelegate {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return characters.count > 0 ? "Characters" : nil
  }
}

extension DetailViewScrollNode: ASTableDataSource {
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }
  
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return characters.count
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    guard characters.count > indexPath.row else { return { ASCellNode() } }
    let character = characters[indexPath.row]
    
    let cellNodeBlock = { () -> ASCellNode in
      let viewModel = CharacterCellViewModel(character: character)
      return CharacterCellNode(with: viewModel)
    }
    return cellNodeBlock
  }
}

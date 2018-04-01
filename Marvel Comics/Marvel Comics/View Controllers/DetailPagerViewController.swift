//
//  DetailPagerViewController.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DetailPagerViewController: UIViewController {
  
  private let pagerNode = ASPagerNode()
  
  private let apiService: APIService
  private let navigator: MarvelNavigator
  private let dataSource: [MarvelComic]
  private let index: Int
  
  init(apiService: APIService, navigator: MarvelNavigator, dataSource: [MarvelComic], index: Int) {
    self.apiService = apiService
    self.navigator = navigator
    self.dataSource = dataSource
    self.index = index
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pagerNode.setDataSource(self)
    
    DispatchQueue.main.async {
      self.view.backgroundColor = UIColor.white
      self.view.addSubnode(self.pagerNode)
      self.pagerNode.scrollToPage(at: self.index, animated: false)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavBar()
  }
  
  private func setupNavBar() {
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.isTranslucent = false
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(goHome))
  }
  
  @objc func goHome(sender: UIBarButtonItem) {
    navigator.showHomePage()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.pagerNode.frame = self.view.bounds
  }
}

extension DetailPagerViewController: ASPagerDataSource {
  func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
    let comic = dataSource[index]
    
    let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
      return DetailViewController(with: comic, apiService: self.apiService)
    }, didLoad: nil)
    
    return node
  }
  func numberOfPages(in pagerNode: ASPagerNode) -> Int {
    return dataSource.count
  }
}


//
//  Navigator.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

import Foundation
import UIKit

protocol Navigator {
  associatedtype Destination
  
  func showHomePage()
  func showDetailPage(dataSource: [MarvelComic], index: Int)
}

class MarvelNavigator: Navigator {
  private weak var navigationController: UINavigationController?
  private let apiService: APIService
  
  init(navigationController: UINavigationController?, apiService: APIService) {
    self.navigationController = navigationController
    self.apiService = apiService
  }
  
  enum Destination {
    case detailPage([MarvelComic], Int)
  }
  
  func showHomePage() {
    navigationController?.popViewController(animated: true)
  }
  
  func showDetailPage(dataSource: [MarvelComic], index: Int) {
    navigate(to: .detailPage(dataSource, index))
  }
  
  private func navigate(to destination: Destination) {
    let viewController = makeViewController(for: destination)
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  private func makeViewController(for destination: Destination) -> UIViewController {
    switch destination {
    case .detailPage(let dataSource, let index): return DetailPagerViewController(apiService: apiService, navigator: self, dataSource: dataSource, index: index)
    }
  }
}

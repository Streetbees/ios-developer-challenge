//
//  MarvelCollectionViewControllerProtocol.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import UIKit

// Contract between collection viewModel class and collection view controller class
protocol MarvelCollectionViewControllerProtocol: class {
    
    func setNavigationTitle(title: String) -> Void
    func setupCollectionView(contentInset: UIEdgeInsets) -> Void
    func updateComicsInCollectionView() -> Void
    func updateView(withErrorTitle errorTitle: String, errorDescription: String) -> Void
    func updatingViewForBetterUserExprienceWhileLoadingComics() -> Void
}

//
//  CollectionViewControllerProtocol.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import UIKit

// Contract between collection view controller class and collection viewModel class
protocol MarvelCollectionViewModelProtocol: class {

    func performInitialSetup() -> Void
    
    func numberOfSections() -> Int
    func numberOfItemsInSection(forSection section: Int) -> Int
    func cellViewModelForItemAtIndexPath(forIndexPath indexPath: IndexPath) -> MarvelCellViewModel?
    func sizeForItemAtIndex(forIndexPath indexPath: IndexPath, withContentSize contentSize: CGSize) -> CGSize
    func model(forIndexPath indexPath: IndexPath) -> Comic?
    
    func minimumInteritemSpacing(forSection section: Int) -> CGFloat
    func minimumLineSpacing(forSection section: Int) -> CGFloat
    
    func retryButtonTapped(sender: Any) -> Void
}


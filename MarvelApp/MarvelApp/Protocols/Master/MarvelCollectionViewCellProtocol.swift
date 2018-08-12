//
//  CollectionViewCellProtocol.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import UIKit

// Contract between collection view cell class and collection cell viewModel class
protocol MarvelCollectionViewCellProtocol: class {
    
    func updateTitle(withTitle title: String) -> Void
    func loadCellImage(withImageUrl url: URL) -> Void
    func roundCoverCorners(withRadius radius: CGFloat) -> Void
}

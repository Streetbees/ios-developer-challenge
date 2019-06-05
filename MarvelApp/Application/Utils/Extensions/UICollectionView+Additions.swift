//
//  UICollectionView+Additions.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 29/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

//extension UICollectionView {
//    func applyChanges<T>(changes: RealmCollectionChange<T>) {
//        switch changes {
//        case .initial: reloadData()
//        case .update(_, let deletions, let insertions, let updates):
//            performBatchUpdates({
//                deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
//                insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
//                reloadItems(at: updates.map { IndexPath(row: $0, section: 0) })
//            }, completion: nil)
//        default: break
//        }
//    }
//}


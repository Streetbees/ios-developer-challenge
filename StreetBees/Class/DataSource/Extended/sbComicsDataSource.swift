//
//  sbComicsDataSource.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsDataSource: CollectionViewDataSource {}

// MARK: - UICollectionViewDelegate Protocol
extension ComicsDataSource
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let section = self.section(at: indexPath.section),
            let comic = section.objects[indexPath.row] as? Comic
        {
            NotificationCenter.default.post(name: SBDataSourceDidSelectNotification,
                                            object: comic)
        }
    }
}


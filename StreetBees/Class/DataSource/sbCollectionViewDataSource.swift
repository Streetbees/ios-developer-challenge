//
//  sbCollectionViewDataSource.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class CollectionViewDataSource: DataSource {}

// MARK: - DataSourceRegistered Protocol
extension CollectionViewDataSource: DataSourceRegistered
{
    func register(_ dataView: UICollectionView)
    {
        dataView.dataSource = self
        dataView.delegate = self
        
        for section in self.allSections()
        {
            if let cellClass = section.cellClass.self
            {
                dataView.register(cellClass,
                                  forCellWithReuseIdentifier: section.reuseIdentifier)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource Protocol
extension CollectionViewDataSource: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    { return self.allSections().count }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        guard let section = self.section(at: section) else
        { return 0 }
        
        return section.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let section = self.allSections()[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.reuseIdentifier,
                                                      for: indexPath)
        
        section.cell(cell, displayObjectAt: indexPath.row)
        
        return cell
    }
}

extension CollectionViewDataSource: UICollectionViewDelegate {}

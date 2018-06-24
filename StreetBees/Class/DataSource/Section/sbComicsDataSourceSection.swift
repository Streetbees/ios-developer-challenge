//
//  sbComicsDataSourceSection.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsDataSourceSection: DataSourceSection {}

extension ComicsDataSourceSection
{
    override var cellClass: AnyClass?
    { return ComicsCollectionViewCell.self }
}

extension ComicsDataSourceSection
{
    override func cell(_ cell: UIView, displayObjectAt index: Int)
    {
        guard let cell = cell as? ComicsCollectionViewCell,
            let comic = self.objects[index] as? Comic else
        { return }
         
        cell.imageView.setImage(URL(string: comic.thumbnail),
                                placeholder: UIImage(named: "placeholder"))
    }
}


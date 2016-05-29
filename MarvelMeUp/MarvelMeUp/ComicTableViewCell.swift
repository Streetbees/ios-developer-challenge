//
//  ComicTableViewCell.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/24/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import UIKit

class ComicTableViewCell: UITableViewCell, CellWithImage {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!

    var imageUrl: NSURL!

}

//
//  ComicTableViewCell.swift
//  MarvelBees
//
//  Created by Andy on 22/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import UIKit

class ComicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var comicThumbnail: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var onSaleDate: UILabel!
    @IBOutlet weak var coverThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        

    }

    
}

//
//  ComicCollectionViewCell.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 28/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    private func configureView() {
        
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 5.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 2.0
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
}

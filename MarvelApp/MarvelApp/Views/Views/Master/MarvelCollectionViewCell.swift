//
//  MarvelCollectionViewCell.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import UIKit
import SDWebImage

class MarvelCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var viewModel: MarvelCellViewModel?
    
    func setup() {
        // Calling setup() method on cell view model to setup the cell
        viewModel?.setup()
    }
    
}

extension MarvelCollectionViewCell: MarvelCollectionViewCellProtocol {
    
    // Updating cell caption title with returned title from cell view model
    func updateTitle(withTitle title: String) {
        captionLabel.text = title
    }
    
    func loadCellImage(withImageUrl url: URL) {
        
        // Start animating the image loading indicator while we're downloading the cell image
        loadingActivityIndicator.startAnimating()
        
        //Fetch and assign cover image to cell image view from server
        coverImageView.sd_setImage(with: url) { (_, _, _, _) in
            
            // Stop image loading indicator animation when image's downloaded
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
    // Round cell cover image corerns with radius value coming back from cell view model
    func roundCoverCorners(withRadius radius: CGFloat) {
        coverImageView.layer.cornerRadius = radius
        coverImageView.layer.masksToBounds = true
    }

    
    
}

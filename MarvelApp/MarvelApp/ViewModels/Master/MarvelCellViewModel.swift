//
//  MarvelCellViewModel.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import UIKit

class MarvelCellViewModel: NSObject {
    
    var marvelCollectionViewCell: MarvelCollectionViewCellProtocol?
    var comic: Comic?
    
    init?(withComicModel comicModel: Comic?) {
        
        guard let comicModel = comicModel else {
            return nil
        }
        
        // Assigning comic model to local comic property
        self.comic = comicModel
        
        super.init()

    }
    
    // Assigning cell view as a delegate
    func setView(view: MarvelCollectionViewCellProtocol) {
        marvelCollectionViewCell = view
    }
    
    
    // Setting up the cell view
    func setup() {
        
        // Unwrapping cell view
        guard let marvelCollectionViewCell = marvelCollectionViewCell else { return }
        
        // Unwrapping all necessary objects to use in cell view
        guard let comic = comic,
              let thumbnail = comic.thumbnail,
              let imagePath = thumbnail.path,
              let imageExt = thumbnail.imageExt,
              let title = comic.title else {
            
                return
        }
        
        // Constructing the image url string by concatination of (ImagePath.ImageExt) values
        let imageUrlString = imagePath + "." + imageExt
        
        // Creating image url from constructed image url string
        let imageUrl = URL(string: imageUrlString)!
        
        // Requesting cell view to load cell image
        marvelCollectionViewCell.loadCellImage(withImageUrl: imageUrl)
        
        // Requesting cell view to update the cell title
        marvelCollectionViewCell.updateTitle(withTitle: title)
        
        // Requesting cell view to round the cover image with specified corner radius
        marvelCollectionViewCell.roundCoverCorners(withRadius: 2)

    }
    
}

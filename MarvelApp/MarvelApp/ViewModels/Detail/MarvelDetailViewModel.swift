//
//  MarvelDetailViewModel.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

class MarvelDetailViewModel: NSObject {
    
    var view: MarvelDetailViewControllerProtocol?
    var comic: Comic?
    
    init(setView view: MarvelDetailViewControllerProtocol?, comicModel: Comic?) {
        
        if let view = view { self.view = view }
        if let comic = comicModel { self.comic = comic }
        
        super.init()
    }
}

extension MarvelDetailViewModel: MarvelDetailViewModelProtocol {
    
    // Peforming initial setup on detail view
    func performInitialSetup() {
        
        // Unwrapping view and comic model to use on detail view screen
        guard let view = view, let comic = comic else { return }
        
        if let thumbnail = comic.thumbnail,
            let imagePath = thumbnail.path,
            let imageExt = thumbnail.imageExt {
            
            // Constructing the image url string by concatination of (ImagePath.ImageExt) values
            let imageUrlString = imagePath + "." + imageExt
            
            // Creating image url from constructed image url string
            let imageUrl = URL(string: imageUrlString)!
            
            // Requesting cell view to load cell image
            view.loadBackroundImage(withImageUrl: imageUrl)
        }
        
        // Setting detail navigation title if comic title is available
        guard let title = comic.title else { return }
        view.setNavigationTitle(withTitle: title)
        
        // Constructing comic title and description
        let description = "\(title)<br /><br />" + (comic.description ?? "No Description Available.")
        
        // Parse html tags in description text if available
        let htmlDescription = description.htmlString
        
        // Updating detail view description text with parsed and constructed string
        view.updateCaptionLabel(withDescription: htmlDescription)
        
        // Requesting view to display the description on screen
        view.addDescriptionViewWithAnimation()

    }
    
    
}

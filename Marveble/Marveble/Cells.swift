//
//  Cells.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import UIKit
import Nuke
import UILoader


class MainCell: UICollectionViewCell, UILoader
{
    //MARK: Model
    var comic: Comic? {
        didSet {
            if let comic = comic {
                self.updateCellImage(withComic: comic)
                self.titleLabel.text = comic.title
                self.descriptionLabel.text = comic.description
            }
        }
    }
    
    func updateCellImage(withComic comic: Comic) {
        self.loading = true
        if let dropboxURL = comic.dropboxPhotoURL, let data = NSData(contentsOfURL: dropboxURL) {
            self.loading = false
            self.coverImage.image = UIImage(data: data)
            return
        }
        if let remoteURL = comic.thumbURL {
            self.coverImage.image = nil
            self.coverImage.nk_setImageWith(remoteURL).completion { [weak self] (response) in
                self?.loading = false
            }
            return
        }
        //Placeholder image
        self.coverImage.image = UIImage(named: "ComicPlaceholder")
        self.loading = false
    }
    
    //MARK: UI
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: UI Loader
    @IBOutlet weak var spinningThing: UIActivityIndicatorView?
    
    func didChangeLoadingStatus(loading: Bool) {
        self.titleLabel.hidden = loading
        self.descriptionLabel.hidden = loading
    }
}

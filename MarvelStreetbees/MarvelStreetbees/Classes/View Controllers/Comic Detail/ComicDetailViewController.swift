//
//  ComicDetailViewController.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AlamofireImage
import Alamofire
import RxCocoa
import FDTake
import TSMessages
import SwiftyDropbox

class ComicDetailViewController: UIViewController {
    
    var viewModel = ComicDetailViewModel()
    
    let disposeBag = DisposeBag()
    let fdTakeController = FDTakeController()
    
    // Outlets
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionString: UILabel!
    @IBOutlet weak var changePictureButton: UIButton!
    @IBOutlet weak var saveToDropboxButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        self.title = "Details".localized
        
        customizeControls()
        
        fdTakeController.didGetPhoto = { [weak self] (image, info) in
            self?.viewModel.thumbnailImage.onNext(image)
        }
        
        setupBindings()
    }
    
    func customizeControls() {
        
        comicImageView.layer.cornerRadius = 4
        comicImageView.layer.masksToBounds = true
        
        changePictureButton.layer.borderColor = changePictureButton.titleLabel?.textColor.CGColor
        changePictureButton.layer.borderWidth = 1
        changePictureButton.layer.cornerRadius = 4
        changePictureButton.layer.masksToBounds = true
        
        changePictureButton.addAction { [weak self] (sender) in
            self?.fdTakeController.present()
        }
        
        saveToDropboxButton.layer.borderColor = saveToDropboxButton.titleLabel?.textColor.CGColor
        saveToDropboxButton.layer.borderWidth = 1
        saveToDropboxButton.layer.cornerRadius = 4
        saveToDropboxButton.layer.masksToBounds = true
    }

}
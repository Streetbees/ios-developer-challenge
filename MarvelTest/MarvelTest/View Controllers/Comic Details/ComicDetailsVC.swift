//
//  ComicDetailsVC.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 18/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit

class ComicDetailsVC: UIViewController {

    var viewModel : ComicVM!
    
    @IBOutlet weak var comicCover: UIImageView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.comicCover.set(assynchronouslyFrom: viewModel.imageURL, at:0)
        self.comicTitle.text = viewModel.comicTitle
    }
}

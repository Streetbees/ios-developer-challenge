//
//  ComicDetailViewController.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 Parhelion Software. All rights reserved.
//

import Foundation
import UIKit

class ComicDetailViewController: UIViewController {
    
    var viewModel = ComicDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.comic?.title
    }
}
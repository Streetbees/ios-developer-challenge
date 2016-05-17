//
//  RootNavigationController.swift
//  Marvel
//
//  Created by Gabriel Massana on 17/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    //MARK: - Accessors

    /**
     ComicsFeedViewController object to be used as rootViewController of the UINavigationController.
     */
    var rootViewController: ComicsFeedViewController = {
        
        let rootViewController: ComicsFeedViewController = ComicsFeedViewController()
        
        return rootViewController
    }()
    
    //MARK: - Init

    init() {
        
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nil, bundle: nil)
    }
}

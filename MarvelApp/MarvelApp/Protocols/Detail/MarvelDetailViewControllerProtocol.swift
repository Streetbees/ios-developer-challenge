//
//  MarvelDetailViewControllerProtocol.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

// Contract between detail viewModel class and detail view controller class
protocol MarvelDetailViewControllerProtocol: class {
    
    func loadBackroundImage(withImageUrl url: URL) -> Void
    func setNavigationTitle(withTitle title: String) -> Void
    func addDescriptionViewWithAnimation()
    func updateCaptionLabel(withDescription description: String) -> Void
}

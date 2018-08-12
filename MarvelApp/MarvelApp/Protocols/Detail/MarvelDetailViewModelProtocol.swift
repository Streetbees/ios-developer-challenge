//
//  MarvelDetailViewModelProtocol.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

// Contract between detail view controller class and detail viewModel class
protocol MarvelDetailViewModelProtocol: class {
    
    func performInitialSetup() -> Void
}

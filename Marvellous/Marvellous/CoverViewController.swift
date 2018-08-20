//
//  CoverViewController.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-20.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import UIKit

class CoverViewController: UIViewController, ViewControllerType {
    // MARK: - ViewControllerType

    var vm: CoverViewModel!
    static let storyboardName = "Main"
    static var identifier = "Cover"

    func bindViewModel() {

    }

    // MARK: - Outlets



}

struct CoverViewModel: ViewModelType {
    // MARK: - ViewControllerType

    let input: Input
    let output: Output

    // MARK: - Implementation

    init(input: Input, output: Output) {
        self.input = input
        self.output = output
    }

    struct Input {

    }

    struct Output {

    }
}

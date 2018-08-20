//
//  ViewControllerType.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-17.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import UIKit

protocol ViewControllerType: class {
    associatedtype ViewModel: ViewModelType

    var vm: ViewModel! { set get }

    static var storyboardName: String { get }
    static var identifier: String { get }

    func bindViewModel()
}

extension ViewControllerType {
    static func instantiate(_ vm: ViewModel) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        vc.vm = vm
        vc.bindViewModel()
        return vc
    }
}

protocol ViewModelType: class {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

class MyViewController: UIViewController, ViewControllerType {
    var vm: MyViewModel!

    static let storyboardName = "Main"
    static let identifier = "XYZ"

    func bindViewModel() {

    }
}

class MyViewModel: ViewModelType {
    struct Input {

    }

    struct Output {

    }

    let input: Input
    let output: Output

    init(input: Input, output: Output) {
        self.input = input
        self.output = output


    }
}






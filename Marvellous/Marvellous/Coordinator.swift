//
//  Coordinator.swift
//  
//
//  Created by Gustaf Kugelberg on 2018-08-23.
//

import UIKit

class Coordinator {
    private var root: UINavigationController!

    static let shared = Coordinator()

    private init() { }

    static func start(with window: UIWindow, comicsProvider: ComicsProviderType) {
        let vm = MasterViewModel(input: .init(comicsProvider: comicsProvider))
        let vc = MasterViewController.instantiate(vm)
        shared.root = window.rootViewController as! UINavigationController
        shared.root.viewControllers = [vc]
    }

    func selectedCell(vm: CoverViewModel) {
        let vc = CoverViewController.instantiate(vm)
        root.present(vc, animated: true, completion: nil)
    }

    func leaveCover() {
        root.dismiss(animated: true, completion: nil)
    }
}

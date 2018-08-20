//
//  MasterViewController.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-17.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import UIKit
import CryptoSwift
import Alamofire

struct ComicsIssue {

}

struct Signer {
    let privateKey: String
    let publicKey: String

    func hash(timestamp: Date) -> String {
        let timestampString = String(timestamp.timeIntervalSinceReferenceDate)
        return (timestampString + privateKey + publicKey).md5()
    }
}

struct ComicsRequest: URLConvertible {
    enum EndPoint: String {
        case comics = "public/comics"

        var version: String {
            switch self {
            case .comics: return "v1"
            }
        }
    }

    private let base = "https://gateway.marvel.com"

    private let endpoint: EndPoint

    // Public

    init(_ endpoint: EndPoint) {
        self.endpoint = endpoint
    }

    func asURL() throws -> URL {
        return URL(string: base)!.appendingPathComponent(endpoint.version).appendingPathComponent(endpoint.rawValue)
    }
}

protocol ComicsProviderType {

}

class ComicsProvider: ComicsProviderType {
    private let signer: Signer

    init(privateKey: String, publicKey: String) {
        self.signer = Signer(privateKey: privateKey, publicKey: publicKey)

        // Test
        Alamofire.request(ComicsRequest(.comics), parameters: parameters(), headers: nil)
            .responseString { response in
                if let value = response.result.value {
                    print("SUCCESS: \(value)")
                }
        }
    }

    private func parameters() -> Parameters {
        let timestamp = Date()
        return ["apikey" : signer.publicKey, "ts" : timestamp.timeIntervalSinceReferenceDate, "hash" : signer.hash(timestamp: timestamp)]
    }
}

class Coordinator {
    private var root: UINavigationController!

    static let shared = Coordinator()

    private init() { }

    static func start(with window: UIWindow, comicsProvider: ComicsProviderType) {
        let vm = MasterViewModel(input: .init(comicsProvider: comicsProvider), output: .init())
        let vc = MasterViewController.instantiate(vm)
        shared.root = window.rootViewController as! UINavigationController
        shared.start(with: vc)
    }

    private func start(with vc: UIViewController) {
        root.viewControllers = [vc]
    }
}

class MasterViewController: UICollectionViewController, ViewControllerType {
    // MARK: - ViewControllerType

    var vm: MasterViewModel!
    static let storyboardName = "Main"
    static let identifier = "Master"

    func bindViewModel() {

    }

    // MARK: - CollectionViewDatasource

}

struct MasterViewModel: ViewModelType {
    // MARK: - ViewControllerType

    let input: Input
    let output: Output

    // MARK: - Implementation

    init(input: Input, output: Output) {
        self.input = input
        self.output = output
    }

    struct Input {
        let comicsProvider: ComicsProviderType
    }

    struct Output {

    }
}

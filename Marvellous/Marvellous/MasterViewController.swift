//
//  MasterViewController.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-17.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import UIKit
import RxSwift

class MasterViewController: UICollectionViewController, ViewControllerType {
    // MARK: - ViewControllerType

    var vm: MasterViewModel!
    static let storyboardName = "Main"
    static let identifier = "Master"

    private var bag = DisposeBag()

    func bindViewModel() {
////        vm.
//
//        vm.input.comicsProvider.getComic(5).debug("COMIC 5").subscribe().disposed(by: bag)
//        vm.input.comicsProvider.getComic(10).debug("COMIC 10").subscribe().disposed(by: bag)
//        vm.input.comicsProvider.getComic(100).debug("COMIC 100").subscribe().disposed(by: bag)
    }

    // MARK: - CollectionViewDatasource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionView COUNT: \(max(100, (try? vm.count.value()) ?? 0))")
        return max(100, (try? vm.count.value()) ?? 0)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath) as! ComicCell
        cell.setup(vm: ComicCellViewModel(comic: vm.comic(offset: indexPath.item)))
        return cell
    }
}

class ComicCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!

    private var vm: ComicCellViewModel!
    private var bag: DisposeBag!

    func setup(vm: ComicCellViewModel) {
        self.bag = DisposeBag()
        self.vm = vm

        vm.title
            .asDriver(onErrorDriveWith: .empty())
            .drive(title.rx.text)
            .disposed(by: bag)
    }
}

struct ComicCellViewModel {
    // Input
    private let comic: Single<Comic>

    // Output
    let title: Single<String>

    // Output
    init(comic: Single<Comic>) {
        self.comic = comic
        self.title = comic.map { $0.title }
    }
}

struct MasterViewModel: ViewModelType {
    private let bag = DisposeBag()

    // MARK: - ViewControllerType

    let input: Input

    // MARK: - Implementation

    init(input: Input) {
        self.input = input

        input.comicsProvider
            .count
            .drive(count)
            .disposed(by: bag)
    }

    struct Input {
        let comicsProvider: ComicsProviderType
    }

    // MARK: - Output

    let count = BehaviorSubject(value: 0)

    func comic(offset: Int) -> Single<Comic> {
        return input.comicsProvider.getComic(offset)
    }
}

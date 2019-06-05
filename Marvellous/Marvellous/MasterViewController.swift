//
//  MasterViewController.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-17.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class MasterViewController: UICollectionViewController, ViewControllerType {
    // MARK: - ViewControllerType

    var vm: MasterViewModel!
    static let storyboardName = "Main"
    static let identifier = "Master"

    private var bag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.count
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [unowned self] _ in self.collectionView?.reloadData(); print("RELOAD") })
            .disposed(by: bag)
    }

    // MARK: - CollectionViewDatasource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(100, (try? vm.count.value()) ?? 0)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath) as! ComicCell
        let cellVm = vm.cellViewModel(offset: indexPath.item)
        cell.bind(vm: cellVm)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVm = vm.coverViewModel(offset: indexPath.item)
        Coordinator.shared.selectedCell(vm: detailVm)
    }
}

class ComicCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private var vm: ComicCellViewModel!
    private var bag: DisposeBag!

    func bind(vm: ComicCellViewModel) {
        self.bag = DisposeBag()
        self.vm = vm

        imageView.image = nil
        title.text = nil
        spinner.startAnimating()

        vm.title
            .asDriver(onErrorDriveWith: .empty())
            .drive(title.rx.text)
            .disposed(by: bag)

        vm.image
            .do(onSuccess: { [weak self] _ in self?.spinner.stopAnimating() })
            .asDriver(onErrorDriveWith: .never())
            .drive(imageView.rx.image)
            .disposed(by: bag)
    }
}

private var placeholderImage: UIImage {
    return UIImage(named: "image_not_available")!
}

func comicImage(_ comic: Comic) -> Single<UIImage> {
    return Observable<UIImage>.create { subscriber in
        if comic.thumbnailPath?.hasSuffix(placeholderPath) ?? true {
            subscriber.onNext(placeholderImage)
        }
        else if let data = comic.thumbnail, let image = UIImage(data: data) {
            subscriber.onNext(image)
        }
        else {
            subscriber.onError(ComicError.noPhoto)
        }
        return Disposables.create()
        }
        .retry(.delayed(maxCount: 10, time: 1))
        .take(1)
        .catchErrorJustReturn(placeholderImage)
        .asSingle()
}

struct ComicCellViewModel {
    // Output
    let title: Single<String>
    let image: Single<UIImage>

    // Init
    init(comic: Single<Comic>) {
        self.title = comic.map { $0.title }
        self.image = comic.flatMap(comicImage)
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

    func cellViewModel(offset: Int) -> ComicCellViewModel {
        return ComicCellViewModel(comic: input.comicsProvider.getComic(offset))
    }

    func coverViewModel(offset: Int) -> CoverViewModel {
        return CoverViewModel(input: .init(comic: input.comicsProvider.getComic(offset)))
    }

    // Helpers
}

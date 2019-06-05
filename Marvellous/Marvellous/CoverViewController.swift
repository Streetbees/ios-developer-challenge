//
//  CoverViewController.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-20.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt

class CoverViewController: UIViewController, ViewControllerType, UIScrollViewDelegate {
    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var exitButton: UIButton!

    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!

    // MARK: - Private

    private let bag = DisposeBag()

    // MARK: - ViewControllerType

    var vm: CoverViewModel!
    static let storyboardName = "Main"
    static var identifier = "Cover"

    private var shouldShowChrome = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateChrome()

        spinner.startAnimating()

        vm.title
            .asDriver(onErrorDriveWith: .empty())
            .drive(titleLabel.rx.text)
            .disposed(by: bag)

        vm.image
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [unowned self] image in
                self.spinner.stopAnimating()
                self.imageView.image = image
                self.imageWidthConstraint.constant = image.size.width
                self.imageHeightConstraint.constant = image.size.height
                self.view.setNeedsLayout()
            })
            .disposed(by: bag)
    }

    override func viewDidLayoutSubviews() {
        let size = imageView.image!.size
        let scale = max(scrollView.frame.size.width/size.width, scrollView.frame.height/size.height);
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
        scrollView.contentOffset = .zero
    }

    @IBAction func didTapImage(_ sender: UITapGestureRecognizer) {
        shouldShowChrome = !shouldShowChrome
        updateChrome()
    }

    @IBAction func didTapExitButton(_ sender: UIButton) {
        Coordinator.shared.leaveCover()
    }

    // ScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // Private

    func updateChrome() {
        titleLabel.isHidden = !shouldShowChrome
        exitButton.isHidden = !shouldShowChrome
    }
}

struct CoverViewModel: ViewModelType {
    // MARK: - ViewControllerType

    let input: Input

    // MARK: - Output

    let title: Single<String>
    let image: Single<UIImage>

    // MARK: - Implementation

    init(input: Input) {
        self.input = input
        self.title = input.comic.map { $0.title }
        self.image = input.comic.flatMap(comicImage)
    }

    struct Input {
        let comic: Single<Comic>
    }
}

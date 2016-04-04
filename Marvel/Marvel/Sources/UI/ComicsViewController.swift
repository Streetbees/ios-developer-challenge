import UIKit
import RxSwift
import RxCocoa
import AutoLayoutPlus

private let cellIdentifier = "cellIdentifier"

class ComicsViewController: UIViewController {
    let viewModel: ComicsViewModel
    let disposeBag = DisposeBag()
    
    lazy var comicsCollectionView: UICollectionView = self.makeComicsCollectionView()
    lazy var dropboxButton: UIButton                = self.makeDropboxButton()
    
    init(viewModel: ComicsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .None, bundle: .None)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupSubviews()
        setupConstraints()
        
        navigationItem.title = "Marvel Comics"
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        setupBindings()
        viewModel.active = true
        
        refreshDropboxButtonTitle()
        
    }
    
    func setupSubviews() {
        view.addSubview(comicsCollectionView)
        view.addSubview(dropboxButton)
    }
    
    func setupConstraints() {
        let views = ["collectionView": comicsCollectionView, "dropboxButton": dropboxButton]
        
        let constraints = NSLayoutConstraint.withFormat([
            "V:|[collectionView][dropboxButton(==50)]|",
            "H:|[collectionView]|",
            "H:|[dropboxButton]|",
        ], views: views)
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeComicsCollectionView() -> UICollectionView {
        let c = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        c.translatesAutoresizingMaskIntoConstraints = false
        c.registerClass(ComicCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.backgroundColor = UIColor.whiteColor()
        c.bounces = false
        c.delegate = self
        
        return c
    }
    
    func makeDropboxButton() -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.blueColor()
        b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        b.addTarget(self, action: #selector(dropboxButtonPressed), forControlEvents: .TouchUpInside)
        
        return b
    }
    
    func setupBindings() {
        viewModel.comics
            .bindTo(comicsCollectionView.rx_itemsWithCellIdentifier(cellIdentifier, cellType: ComicCell.self)) { (row, element, cell) in
                let cellViewModel = ComicCellViewModel(model: element)
                cell.configure(cellViewModel)
            }
            .addDisposableTo(disposeBag)
        
        ImageLoaderService.service.downloadedImage
            .observeOn(MainScheduler.instance)
            .subscribeNext { comic in
                if let index = self.viewModel.model.indexOf(comic) {
                    let path = NSIndexPath(forRow: index, inSection: 0)
                    self.comicsCollectionView.reloadItemsAtIndexPaths([path])
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func dropboxButtonPressed() {
        if !DBSession.sharedSession().isLinked() {
            DBSession.sharedSession().linkFromController(self)
        } else {
            DBSession.sharedSession().unlinkAll()
            refreshDropboxButtonTitle()
        }
    }
    
    func refreshDropboxButtonTitle() {
        let title = DBSession.sharedSession().isLinked() ? "Unlink Dropbox" : "Link Dropbox"
        dropboxButton.setTitle(title, forState: .Normal)
    }
}

extension ComicsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = view.bounds.size.width / 3
        return CGSizeMake(width, width * 1.3)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailsViewModel = ComicDetailsViewModel(model: viewModel.model[indexPath.row])
        let detailsScreen = ComicDetailsViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailsScreen, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - (scrollView.frame.size.height * 3) {
            viewModel.fetchNextBatchOfComics()
        }
    }
}

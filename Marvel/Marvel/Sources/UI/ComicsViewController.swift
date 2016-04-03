import UIKit
import RxSwift
import RxCocoa
import AutoLayoutPlus

private let cellIdentifier = "cellIdentifier"

class ComicsViewController: UIViewController {

    let viewModel = ComicsViewModel()
    let disposeBag = DisposeBag()
    
    lazy var comicsCollectionView: UICollectionView = self.makeComicsCollectionView()
    
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
    }
    
    func setupSubviews() {
        view.addSubview(comicsCollectionView)
    }
    
    func setupConstraints() {
        let constraints = comicsCollectionView.likeParent()
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeComicsCollectionView() -> UICollectionView {
        let c = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        c.translatesAutoresizingMaskIntoConstraints = false
        c.registerClass(ComicCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.backgroundColor = UIColor.whiteColor()
                
        c.rx_setDelegate(self)
            .addDisposableTo(disposeBag)
        
        return c
    }
    
    func setupBindings() {
        viewModel.comics
            .bindTo(comicsCollectionView.rx_itemsWithCellIdentifier(cellIdentifier, cellType: ComicCell.self)) { (row, element, cell) in
                cell.viewModel = ComicCellViewModel(model: element)
            }
            .addDisposableTo(disposeBag)
        
        viewModel.thumbnailLoaded
            .subscribeNext { (index, comic) in
                let cell = self.comicsCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? ComicCell
                cell?.viewModel?.model = comic
            }.addDisposableTo(disposeBag)
    }
}

extension ComicsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = view.bounds.size.width / 2
        return CGSizeMake(width, width * 1.5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        do {
            let comic: Comic = try collectionView.rx_modelAtIndexPath(indexPath)
            let viewModel = ComicDetailsViewModel(model: comic)
            
            let detailsScreen = ComicDetailsViewController(viewModel: viewModel)
            navigationController?.pushViewController(detailsScreen, animated: true)
        } catch {}
    }
}

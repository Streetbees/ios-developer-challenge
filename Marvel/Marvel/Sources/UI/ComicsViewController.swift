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
        view.backgroundColor = UIColor.redColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
        c.rx_setDelegate(self)
            .addDisposableTo(disposeBag)
        
        return c
    }
    
    func setupBindings() {
        viewModel.comics
            .bindTo(comicsCollectionView.rx_itemsWithCellIdentifier(cellIdentifier)) { (row, element, cell) in
                guard let comicCell = cell as? ComicCell else { return }
            }
            .addDisposableTo(disposeBag)
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
        print("selected item at indexPath: \(indexPath)")
    }
}

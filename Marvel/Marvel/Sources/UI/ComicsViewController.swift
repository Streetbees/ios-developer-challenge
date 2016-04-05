import UIKit
import RxSwift
import RxCocoa
import AutoLayoutPlus
import SwiftyDropbox

private let defaultLimit = 1

class ComicsViewController: UIViewController {
    let disposeBag = DisposeBag()
    let cellIdentifier = "cellIdentifier"
    
    var comics: [Comic] = []
    var currentOffset = 0
    var isLoadingData = false
    
    var dropboxLinked: Bool {
        return ImageLoaderService.service.dropboxLinked
    }
    
    lazy var comicsCollectionView: UICollectionView = self.makeComicsCollectionView()
    lazy var dropboxButton: UIButton                = self.makeDropboxButton()
    
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
        refreshDropboxButtonTitle()
        
        loadNextComicBatch()
    }
            
    func setupBindings() {
        ImageLoaderService.service.downloadedImage
            .observeOn(MainScheduler.instance)
            .subscribeNext { comic in
                if let index = self.comics.indexOf(comic) {
                    let path = NSIndexPath(forRow: index, inSection: 0)
                    self.comicsCollectionView.reloadItemsAtIndexPaths([path])
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func dropboxButtonPressed() {
        if dropboxLinked {
            Dropbox.unlinkClient()
            refreshDropboxButtonTitle()
            
            comics.forEach { $0.dropboxThumbnail = .None }
            comicsCollectionView.reloadItemsAtIndexPaths(comicsCollectionView.indexPathsForVisibleItems())
        } else {
            Dropbox.authorizeFromController(self)
        }
    }
    
    func refreshDropboxButtonTitle() {
        if let _ = Dropbox.authorizedClient {
            dropboxButton.setTitle("  Unlink Dropbox", forState: .Normal)
        } else {
            dropboxButton.setTitle("  Link Dropbox", forState: .Normal)
        }
    }
    
    func loadNextComicBatch() {
        if !isLoadingData {
            isLoadingData = true
            MarvelAPI.api.listComics(currentOffset, limit: defaultLimit, onSuccess: obtainedComics, onFailure: failedToObtainComics)
        }
    }
    
    func obtainedComics(comicData: ComicDataContainer) {
        guard let moreComics = comicData.comics, count = comicData.count else {
            return
        }
        
        let oldComicCount = comics.count
        comics += moreComics
        currentOffset += count
        
        let newIndexes = (oldComicCount..<comics.count).map { NSIndexPath(forItem: $0, inSection: 0) }
        comicsCollectionView.insertItemsAtIndexPaths(newIndexes)
        
        isLoadingData = false
    }
    
    func failedToObtainComics(failure: RequestFailed) {
        // Retry, show message, etc
        isLoadingData = false
    }
}

extension ComicsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ComicCell
        
        let comic = comics[indexPath.row]
        cell.configure(comic)
        
        return cell
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
        let detailsScreen = ComicDetailsViewController(comic: comics[indexPath.row])
        navigationController?.pushViewController(detailsScreen, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - (scrollView.frame.size.height * 3) {
            loadNextComicBatch()
        }
    }
}

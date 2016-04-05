import UIKit
import SwiftyDropbox

private let defaultLimit = 30

class ComicsViewController: UIViewController {
    let cellIdentifier = "cellIdentifier"
    
    var comics: [Comic] = []
    var currentOffset = 0
    var isLoadingData = false
    
    var dropboxLinked: Bool {
        return ImageLoaderService.service.dropboxLinked
    }
    
    lazy var comicsCollectionView: UICollectionView       = self.makeComicsCollectionView()
    lazy var dropboxButton: UIButton                      = self.makeDropboxButton()
    lazy var moreComicsIndicator: UIActivityIndicatorView = self.makeMoreComicsIndicator()
    
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
        
        refreshDropboxButtonTitle()
        loadNextComicBatch()
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dropboxLinkHandler), name: Notification.dropboxLinkNotification, object: .None)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadVisibleItems()
    }
    
    func dropboxButtonPressed() {
        if dropboxLinked {
            Dropbox.unlinkClient()
            showSuccess("Dropbox unlinked")
            refreshDropboxButtonTitle()
            
            comics.forEach { $0.dropboxThumbnail = .None }
            reloadVisibleItems()
        } else {
            Dropbox.authorizeFromController(self)
        }
    }
    
    func refreshDropboxButtonTitle() {
        let title =  dropboxLinked ? "  Unlink Dropbox" : "  Link Dropbox"
        dropboxButton.setTitle(title, forState: .Normal)
    }
    
    func loadNextComicBatch() {
        if !isLoadingData {
            isLoadingData = true
            
            moreComicsIndicator.hidden = currentOffset == 0
            if !moreComicsIndicator.hidden {
                moreComicsIndicator.startAnimating()
            }
            
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
        
        moreComicsIndicator.stopAnimating()
        moreComicsIndicator.hidden = true
        
        isLoadingData = false
    }
    
    func failedToObtainComics(failure: RequestFailed) {
        moreComicsIndicator.stopAnimating()
        moreComicsIndicator.hidden = true
        
        isLoadingData = false
    }
    
    func dropboxLinkHandler(notification: NSNotification) {
        if let info = notification.userInfo, success = info[Notification.dropboxLinkSuccessKey] as? Bool where success {
            showSuccess("Linked to Dropbox")
            reloadVisibleItems()
        } else {
            showError("Failed to link to Dropbox")
        }
        
        refreshDropboxButtonTitle()
    }
    
    func reloadVisibleItems() {
        comicsCollectionView.reloadItemsAtIndexPaths(comicsCollectionView.indexPathsForVisibleItems())
    }
}

extension ComicsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ComicCell
        cell.configure(comics[indexPath.row])
        
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
        if scrollView.contentOffset.y >= scrollView.contentSize.height - (scrollView.frame.size.height * 2) {
            loadNextComicBatch()
        }
    }
}

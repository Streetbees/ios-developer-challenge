import UIKit
import SwiftyDropbox

private let defaultLimit = 30

class ComicsViewController: UIViewController {
    let cellIdentifier = "cellIdentifier"
    
    var comics: [Comic] = []
    var currentOffset = 0
    var isLoadingData = false
    
    var dropboxLinked: Bool { return DropboxService.service.dropboxLinked }
    
    var bannerView: BannerView?
    var bannerViewTap: UITapGestureRecognizer?
    
    lazy var comicsCollectionView: UICollectionView       = self.makeComicsCollectionView()
    lazy var dropboxButton: UIButton                      = self.makeDropboxButton()
    lazy var moreComicsIndicator: UIActivityIndicatorView = self.makeMoreComicsIndicator()
    
    override func loadView() {
        super.loadView()
        
        setupSubviews()
        setupConstraints()
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialUI()
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
            
            ImagesCache.instance.dropboxCache.removeAllObjects()
            reloadVisibleItems()
        } else {
            Dropbox.authorizeFromController(self)
        }
    }
    
    func refreshDropboxButtonTitle() {
        let title = dropboxLinked ? "  Unlink Dropbox" : "  Link Dropbox"
        dropboxButton.setTitle(title, forState: .Normal)
    }
    
    func loadNextComicBatch() {
        if !isLoadingData {
            let firstBatch = currentOffset == 0
            startLoading(firstBatch)
                        
            MarvelAPI.api.listComics(currentOffset, limit: defaultLimit, onSuccess: obtainedComics, onFailure: failedToObtainComics)
        }
    }
    
    func obtainedComics(comicData: ComicDataContainer) {
        guard let moreComics = comicData.comics, count = comicData.count else { return }
        
        let previousComicCount = comics.count
        comics += moreComics
        currentOffset += count
        
        let newIndexes = (previousComicCount..<comics.count).map { NSIndexPath(forItem: $0, inSection: 0) }
        comicsCollectionView.insertItemsAtIndexPaths(newIndexes)
        
        let firstBatch = comics.count == count
        endLoadingSuccess(firstBatch)
    }
    
    func failedToObtainComics(failure: RequestFailed) {
        let firstBatch = comics.isEmpty
        endLoadingFailure(firstBatch, message: failure.description)
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
    
    func bannerTapped() {
        bannerViewTap?.enabled = false
        bannerView?.showLoading()
        loadNextComicBatch()
    }
    
    func displayBanner() {
        bannerViewTap = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        bannerViewTap?.enabled = false
        
        bannerView = makeBannerView()
        bannerView?.addGestureRecognizer(bannerViewTap!)
        
        view.addSubview(bannerView!)
        NSLayoutConstraint.activateConstraints(bannerView!.likeParent())
    }
    
    func setupInitialUI() {
        edgesForExtendedLayout = .None
        navigationItem.title = "Marvel Comics"
        refreshDropboxButtonTitle()
        displayBanner()
    }
    
    func startLoading(firstBatch: Bool) {
        isLoadingData = true
        
        moreComicsIndicator.hidden = firstBatch
        if !firstBatch {
            moreComicsIndicator.startAnimating()
        }
    }
    
    func endLoadingSuccess(firstBatch: Bool) {
        if firstBatch {
            bannerView?.removeFromSuperview()
            bannerViewTap = .None
        } else {
            moreComicsIndicator.stopAnimating()
            moreComicsIndicator.hidden = true
        }
        
        isLoadingData = false
    }
    
    func endLoadingFailure(firstBatch: Bool, message: String) {
        if firstBatch {
            bannerView?.showError(message)
            bannerViewTap?.enabled = true
        } else {
            showError(message)
            moreComicsIndicator.stopAnimating()
            moreComicsIndicator.hidden = true
        }
        
        isLoadingData = false
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
        let comic = comics[indexPath.row]
        let marvelThumbnail = ImagesCache.instance.marvelCache[comic.id!]
        let dropboxThumbnail = ImagesCache.instance.dropboxCache[comic.id!]
        
        let detailsScreen = ComicDetailsViewController(comic: comic, marvelThumbnail: marvelThumbnail, dropboxThumbnail: dropboxThumbnail)
        navigationController?.pushViewController(detailsScreen, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - (scrollView.frame.size.height * 2) {
            loadNextComicBatch()
        }
    }
}

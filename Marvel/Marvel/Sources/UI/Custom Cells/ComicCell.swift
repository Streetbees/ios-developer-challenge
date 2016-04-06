import UIKit
import RxSwift

class ComicCell: UICollectionViewCell {
    
    var comic: Comic?
    
    lazy var comicImageView: UIImageView    = self.makeComicImageView()
    lazy var infoContainer: UIView          = self.makeInfoContainer()
    lazy var titleLabel: UILabel            = self.makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.whiteColor().CGColor
        contentView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(comic: Comic) {
        self.comic = comic
        
        titleLabel.text = comic.title
        comicImageView.image = defineImageToDisplay(comic)
        
        loadMissingThumbnails(comic)
    }
    
    func defineImageToDisplay(comic: Comic) -> UIImage {
        let dropboxImage = ImagesCache.instance.dropboxCache[comic.id!]
        let marvelImage = ImagesCache.instance.marvelCache[comic.id!]
        
        let image: UIImage
        if let fromDropbox = dropboxImage {
            image = fromDropbox
        } else if let fromMarvel = marvelImage {
            image = fromMarvel
        } else {
            image = UIImage.coverPlaceholder()
        }
        
        return image
    }
    
    func loadMissingThumbnails(comic: Comic) {
        let fromDropbox = ImagesCache.instance.dropboxCache[comic.id!]
        let fromMarvel = ImagesCache.instance.marvelCache[comic.id!]
        
        if fromDropbox == .None && DropboxService.service.dropboxLinked {
            loadMissingDropboxThumbnail(comic)
        }
        
        if fromMarvel == .None {
            loadMissingMarvelThumbnail(comic)
        }
    }
    
    func loadMissingMarvelThumbnail(comic: Comic) {
        MarvelAPI.api.downloadComicThumbnailFromMarvel(comic, completion: { image in
            dispatch_async(dispatch_get_main_queue()) {
                if let loadedImage = image {
                    ImagesCache.instance.marvelCache[comic.id!] = loadedImage
                    self.showLoadedImageForComic(comic)
                }
            }
        })
    }
    
    func loadMissingDropboxThumbnail(comic: Comic) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            DropboxService.service.downloadComicThumbnailFromDropbox(comic, completion: { image in
                dispatch_async(dispatch_get_main_queue()) {
                    if let loadedImage = image {
                        ImagesCache.instance.dropboxCache[comic.id!] = loadedImage
                        self.showLoadedImageForComic(comic)
                    }
                }
            })
        }
    }
    
    func showLoadedImageForComic(comic: Comic) {
        guard let currentComic = self.comic else { return }
        
        if currentComic.id! == comic.id! {
            comicImageView.image = self.defineImageToDisplay(comic)
        }
    }
}

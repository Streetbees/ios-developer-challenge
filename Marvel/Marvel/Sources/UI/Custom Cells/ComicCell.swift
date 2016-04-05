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
        guard let id = comic.id else { return }
        
        self.comic = comic
        
        titleLabel.text = comic.title
        comicImageView.image = defineImageToDisplay(comic)
        tag = id
        
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
        
        if fromDropbox == .None && ImageLoaderService.service.dropboxLinked {
            ImageLoaderService.service.downloadComicThumbnailFromDropbox(comic, completion: { image in
                dispatch_async(dispatch_get_main_queue()) {
                    ImagesCache.instance.dropboxCache[comic.id!] = image
                    
                    if self.tag == comic.id! {
                        self.comicImageView.image = self.defineImageToDisplay(comic)
                    }
                }
            })
        }
        
        if fromMarvel == .None {
            MarvelAPI.api.downloadComicThumbnailFromMarvel(comic, completion: { image in
                dispatch_async(dispatch_get_main_queue()) {
                    ImagesCache.instance.marvelCache[comic.id!] = image
                    
                    if self.tag == comic.id! {
                        self.comicImageView.image = self.defineImageToDisplay(comic)
                    }
                }
            })
        }
    }

}

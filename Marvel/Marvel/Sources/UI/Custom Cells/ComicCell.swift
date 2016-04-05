import UIKit
import RxSwift

class ComicCell: UICollectionViewCell {
    
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
        titleLabel.text = comic.title
        comicImageView.image = defineImageToDisplay(comic)
        
        loadMissingThumbnails(comic)
    }
    
    func defineImageToDisplay(comic: Comic) -> UIImage {
        let image: UIImage
        
        if let dropboxImage = comic.dropboxThumbnail {
            image = dropboxImage
        } else if let marvelImage = comic.thumbnail {
            image = marvelImage
        } else {
            image = UIImage.coverPlaceholder()
        }
        
        return image
    }
    
    func loadMissingThumbnails(comic: Comic) {
        if comic.dropboxThumbnail == .None {
            ImageLoaderService.service.downloadFileFromDropbox(comic)
        }
        
        if comic.thumbnail == .None {
            ImageLoaderService.service.downloadComicThumbnailFromMarvel(comic)
        }
    }
}

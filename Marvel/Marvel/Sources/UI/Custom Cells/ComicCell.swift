import UIKit
import RxSwift

class ComicCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var viewModel: ComicCellViewModel? {
        didSet {
            setupBindings()
            viewModel?.active = true
        }
    }
    
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
    
    func setupSubviews() {
        contentView.addSubview(comicImageView)
        contentView.addSubview(infoContainer)
    }
    
    func setupConstraints() {
        let views = ["comicImageView": comicImageView, "infoContainer": infoContainer]
        
        var constraints = NSLayoutConstraint.withFormat([
            "V:[infoContainer(==50)]|",
            "H:|[infoContainer]|",
        ], views: views)
        
        constraints += comicImageView.likeParent()
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeComicImageView() -> UIImageView {
        let i = UIImageView(image: UIImage.coverPlaceholder())
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .ScaleAspectFill
        
        return i
    }
    
    func makeInfoContainer() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        v.addSubview(titleLabel)
        
        var constraints = NSLayoutConstraint.withFormat([
            "H:|-10-[titleLabel]-10-|",
        ], views: ["titleLabel": titleLabel])
        
        constraints += titleLabel.centeredInParent()
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        return v
    }
    
    func makeTitleLabel() -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 2
        l.textColor = UIColor.whiteColor()
        l.font = UIFont.marvelRegular(14)
        
        return l
    }
    
    func setupBindings() {
        viewModel?.title.bindTo(titleLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel?.thumbnail.subscribeNext({ image in
            if let i = image {
                self.comicImageView.image = i
            } else {
                self.comicImageView.image = UIImage.coverPlaceholder()
                self.viewModel?.loadImage()
            }
        }).addDisposableTo(disposeBag)
    }
    
    func configure(viewModel: ComicCellViewModel) {
        self.viewModel = viewModel
    }
}

import UIKit

extension ComicCell {
    
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
    
}
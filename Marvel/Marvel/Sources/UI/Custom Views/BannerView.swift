import Foundation
import UIKit

private let loadingText = "Loading comics"

class BannerView: UIView {
    
    lazy var logo: UIImageView                  = self.makeLogo()
    lazy var label: UILabel                     = self.makeLabel()
    lazy var indicator: UIActivityIndicatorView = self.makeIndicator()
    lazy var bottomImage: UIImageView           = self.makeBottomImage()
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupSubviews()
        setupConstraints()
        
        backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(logo)
        addSubview(label)
        addSubview(indicator)
        addSubview(bottomImage)
    }
    
    func setupConstraints() {
        let views = ["logo": logo, "label": label, "indicator": indicator, "bottomImage": bottomImage]
        
        var constraints = NSLayoutConstraint.withFormat([
            "V:|-20-[logo]",
            "V:[label]-10-[indicator]",
            "V:[bottomImage(==200)]|",
            "H:|[bottomImage]|",
            "H:|-10-[label]-10-|",
            ], views: views)
        
        constraints += [logo.centeredInParentX()]
        constraints += indicator.centeredInParent()
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeLogo() -> UIImageView {
        let l = UIImageView(image: UIImage.marvelLogo())
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }
    
    func makeLabel() -> UILabel {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.marvelRegular(16)
        l.numberOfLines = 0
        l.textAlignment = .Center
        l.text = loadingText
        
        return l
    }

    func makeIndicator() -> UIActivityIndicatorView {
        let a = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.startAnimating()
        
        return a
    }
    
    func makeBottomImage() -> UIImageView {
        let i = UIImageView(image: UIImage.bannerImage())
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .ScaleAspectFill
        
        return i
    }
    
    func showError(description: String) {
        label.text = "\(description).\n\nTap to retry."
        indicator.hidden = true
    }
    
    func showLoading() {
        label.text = loadingText
        indicator.hidden = false
    }
}

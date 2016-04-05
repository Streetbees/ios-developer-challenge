import UIKit
import AutoLayoutPlus

extension ComicsViewController {
    
    func setupSubviews() {
        view.addSubview(comicsCollectionView)
        view.addSubview(dropboxButton)
        view.addSubview(moreComicsIndicator)
    }
    
    func setupConstraints() {
        let views = ["collectionView": comicsCollectionView, "dropboxButton": dropboxButton, "moreComicsIndicator": moreComicsIndicator]
        
        var constraints = NSLayoutConstraint.withFormat([
            "V:|[collectionView][dropboxButton(==50)]|",
            "V:[moreComicsIndicator]-5-[dropboxButton]",
            "H:|[collectionView]|",
            "H:|[dropboxButton]|",
            ], views: views)
        
        constraints += [moreComicsIndicator.centeredInParentX()]
                
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeComicsCollectionView() -> UICollectionView {
        let c = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        c.translatesAutoresizingMaskIntoConstraints = false
        c.registerClass(ComicCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.backgroundColor = UIColor.whiteColor()
        c.delegate = self
        c.dataSource = self
        
        return c
    }
    
    func makeDropboxButton() -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        b.setImage(UIImage.iconDropbox(), forState: .Normal)
        b.addTarget(self, action: #selector(dropboxButtonPressed), forControlEvents: .TouchUpInside)
        
        return b
    }
    
    func makeMoreComicsIndicator() -> UIActivityIndicatorView {
        let a = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.hidden = true
        
        return a
    }
    
    func makeBannerView() -> BannerView {
        let b = BannerView()
        b.translatesAutoresizingMaskIntoConstraints = false
        
        return b
    }
    
}

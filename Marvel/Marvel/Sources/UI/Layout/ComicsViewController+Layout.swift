import UIKit

extension ComicsViewController {
    
    func setupSubviews() {
        view.addSubview(comicsCollectionView)
        view.addSubview(dropboxButton)
    }
    
    func setupConstraints() {
        let views = ["collectionView": comicsCollectionView, "dropboxButton": dropboxButton]
        
        let constraints = NSLayoutConstraint.withFormat([
            "V:|[collectionView][dropboxButton(==50)]|",
            "H:|[collectionView]|",
            "H:|[dropboxButton]|",
            ], views: views)
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeComicsCollectionView() -> UICollectionView {
        let c = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        c.translatesAutoresizingMaskIntoConstraints = false
        c.registerClass(ComicCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.backgroundColor = UIColor.whiteColor()
        c.bounces = false
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
}

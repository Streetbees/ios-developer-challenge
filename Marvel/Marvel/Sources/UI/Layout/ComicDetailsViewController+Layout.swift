import UIKit

extension ComicDetailsViewController {
    
    func setupSubviews() {
        view.addSubview(detailsTableView)
    }
    
    func setupConstraints() {
        let constraints = detailsTableView.likeParent()
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeDetailsTableView() -> UITableView {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        t.tableHeaderView = comicThumbnail
        t.separatorStyle = .None
        t.rowHeight = UITableViewAutomaticDimension
        t.estimatedRowHeight = 100
        t.dataSource = self
        t.delegate = self
        
        return t
    }
    
    func makeComicThumbnail() -> UIImageView {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 300)
        let i = UIImageView(frame: frame)
        i.userInteractionEnabled = true
        i.contentMode = .ScaleAspectFit
        i.backgroundColor = UIColor.blackColor()
        i.image = UIImage.coverPlaceholder()
        
        i.addSubview(removeButton)
        i.addSubview(cameraButton)
        
        let constraints = NSLayoutConstraint.withFormat([
            "V:[removeButton(==50)]-10-[cameraButton(==50)]-10-|",
            "H:[removeButton(==50)]-10-|",
            "H:[cameraButton(==50)]-10-|",
            ], views: ["removeButton": removeButton, "cameraButton": cameraButton])
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        return i
    }
    
    func makeTitleLabel() -> UILabel {
        let l = UILabel(frame: CGRect.zero)
        l.font = UIFont.marvelRegular(16)
        l.textAlignment = .Center
        l.numberOfLines = 2
        l.textColor = UIColor.whiteColor()
        l.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        
        return l
    }
    
    func makeProgressView() -> UIProgressView {
        let p = UIProgressView()
        return p
    }
    
}

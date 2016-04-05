import UIKit
import AutoLayoutPlus

extension ComicDetailsViewController {
    
    func setupSubviews() {
        view.addSubview(detailsTableView)
        view.addSubview(progressBar)
    }
    
    func setupConstraints() {
        let views = ["detailsTableView": detailsTableView, "progressBar": progressBar]
        
        var constraints = NSLayoutConstraint.withFormat([
            "V:|[progressBar(==4)]",
            "H:|[progressBar]|",
        ], views: views)
        
        constraints += detailsTableView.likeParent()
        
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
    
    func makeProgressBar() -> UIProgressView {
        let p = UIProgressView(progressViewStyle: .Default)
        p.translatesAutoresizingMaskIntoConstraints = false
        p.progressTintColor = UIColor.success()
        p.hidden = true
        
        return p
    }
    
    func makeTitleActivityIndicator() -> UIView {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = "Saving"
        titleLabel.font = UIFont.marvelRegular(14)
        
        let fittingSize = titleLabel.sizeThatFits(CGSize(width: 200, height: activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRect(x: activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8, y: activityIndicatorView.frame.origin.y, width: fittingSize.width, height: fittingSize.height)
        
        let titleView = UIView(frame: CGRect(x: ((activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2), y: ((activityIndicatorView.frame.size.height) / 2), width: (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width), height: (activityIndicatorView.frame.size.height)))
        
        titleView.addSubview(activityIndicatorView)
        titleView.addSubview(titleLabel)
        
        return titleView
    }
    
    func makeCircularButton(target: AnyObject?, action: Selector, icon: UIImage) -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.grayColor()
        b.setImage(icon, forState: .Normal)
        b.clipsToBounds = true
        b.layer.cornerRadius = 25
        b.layer.borderColor = UIColor.whiteColor().CGColor
        b.layer.borderWidth = 2
        b.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        return b
    }
}

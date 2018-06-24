//
//  sbComicsView.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


enum Activity
{
    case none
    case loading
}

class ComicsView: UIView
{
    // MARK: - Property(s)
    
    private(set) lazy var collectionView: UICollectionView =
    { [unowned self] in
        
        let anObject = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        anObject.showsHorizontalScrollIndicator = false
        anObject.isScrollEnabled = true
        // anObject.isPagingEnabled = true /* WTF */
        anObject.backgroundColor = UIColor.clear
        anObject.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        self.insertSubview(anObject, aboveSubview: self.imageView)
        return anObject
    }()
    
    private(set) lazy var imageView: UIImageView =
    { [unowned self] in
        
        let anObject = UIImageView(image: UIImage(named: "space"))
        anObject.contentMode = .scaleAspectFill
        
        self.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Hidden Property(s)
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView =
    { [unowned self] in
        
        let anObject = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        self.insertSubview(anObject, aboveSubview: self.imageView)
        return anObject
    }()
    
    fileprivate lazy var layout: UICollectionViewFlowLayout =
    { [unowned self] in
        
        let anObject = UICollectionViewFlowLayout()
        anObject.itemSize = ComicsCollectionViewCell.fixedSize
        anObject.scrollDirection = .horizontal
        anObject.minimumInteritemSpacing = 0
        anObject.minimumLineSpacing = ComicsView.marginSize.width
        
        return anObject
    }()
    
    
    // MARK: -
    
    func setActivity(_ activity: Activity, animated: Bool) /* TODO:Support abstraction ... */
    {
        if animated
        {
            UIView.animate(withDuration: 0.3) /* TODO:Support constant ... */
            {
                self.activityIndicator.alpha = activity == .loading ? 1.0 : 0.0
                self.collectionView.alpha = activity == .loading ? 0.0 : 1.0
            }
        }
        else
        {
            self.activityIndicator.alpha = activity == .loading ? 1.0 : 0.0
            self.collectionView.alpha = activity == .loading ? 0.0 : 1.0
        }
        
        switch activity
        {
        case .loading:
            self.activityIndicator.startAnimating()
        case .none:
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    // MARK: - Creating a View Object
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layoutMargins = UIEdgeInsets(top: 40.0, left: 0, bottom: 40.0, right: 0) // iOS 8.0+
        self.updateLayout(nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.imageView.frame = self.bounds
    }
}

// MARK: - GeometryLayout Protocol
extension ComicsView: GeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.layoutMarginsGuide
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 0).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: 0).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    }
}

// MARK: - GeometrySpacing Protocol
extension ComicsView: GeometrySpacing
{
    static var marginSize: CGSize
    { return CGSize(width: 18, height: 18) }
}


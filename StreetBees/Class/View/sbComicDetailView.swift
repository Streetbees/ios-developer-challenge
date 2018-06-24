//
//  sbComicDetailView.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicDetailView: UIView
{
    // MARK: - Property(s)
    
    private(set) lazy var imageView: CustomImageView =
    { [unowned self] in
        
        let anObject = CustomImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFit
        
        self.addSubview(anObject)
        return anObject
    }()
    
    private(set) lazy var backroundView: UIView =
    {
        let anObject = UIView(frame: .zero)
        anObject.backgroundColor = UIColor.black
        anObject.alpha = 0.0
        
        self.insertSubview(anObject, at: 0)
        return anObject
    }()
    
    
    // MARK: - Hidden Property(s)
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView =
    { [unowned self] in
        
        let anObject = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        self.insertSubview(anObject, aboveSubview: self.imageView)
        return anObject
    }()
    
    
    // MARK: -
    
    func setActivity(_ activity: Activity, animated: Bool)
    {
        if animated
        {
            UIView.animate(withDuration: 0.3)
            {
                self.activityIndicator.alpha = activity == .loading ? 1.0 : 0.0
                self.imageView.alpha = activity == .loading ? 0.0 : 1.0
            }
        }
        else
        {
            self.activityIndicator.alpha = activity == .loading ? 1.0 : 0.0
            self.imageView.alpha = activity == .loading ? 0.0 : 1.0
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
        
        self.updateLayout(nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.imageView.frame = self.bounds
        self.backroundView.frame = self.bounds
    }
}

// MARK: - GeometryLayout Protocol
extension ComicDetailView: GeometryLayout
{
    func updateLayout(_ container: UIView?)
    {
        let guide = self.layoutMarginsGuide
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    }
}


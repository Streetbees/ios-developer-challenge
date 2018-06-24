//
//  sbComicsCollectionViewCell.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsCollectionViewCell: UICollectionViewCell
{
    // MARK: - Property(s)
    
    private(set) lazy var imageView: CustomImageView =
    { [unowned self] in
        
        let anObject = CustomImageView(frame: .zero)
        anObject.contentMode = .scaleAspectFit
        anObject.backgroundColor = UIColor.white
        anObject.layer.borderColor = UIColor.white.cgColor
        anObject.layer.borderWidth = 3.0
        anObject.layer.shadowOpacity = 0.3 /* Not really neccessary, but lifts it off the background. */
        anObject.layer.shadowRadius = 3.0
        
        self.contentView.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Laying out Subviews
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.imageView.frame = self.contentView.bounds
    }
}

extension ComicsCollectionViewCell: Geometry
{
    static var fixedSize: CGSize
    {
        return CGSize(width: 100, height: 140).scale(.iPhone6Plus)
    }
}


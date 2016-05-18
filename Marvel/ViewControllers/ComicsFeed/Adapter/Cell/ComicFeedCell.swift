//
//  ComicFeedCell.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

class ComicFeedCell: TableViewCell {

    //MARK: - Accessors
    
    var comic: Comic?
    
    /**
     Label with the Comic title.
     */
    private var titleLabel: UILabel = {
        
        let titleLabel: UILabel = UILabel.newAutoLayoutView()
        
        titleLabel.backgroundColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Left
        titleLabel.font = UIFont.tradeGothicNo2BoldWithSize(17.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        return titleLabel
    }()
    
    /**
     Label with the Comic description.
     */
    private var descriptionLabel: UILabel = {
        
        let descriptionLabel: UILabel = UILabel.newAutoLayoutView()
        
        descriptionLabel.backgroundColor = UIColor.whiteColor()
        descriptionLabel.textAlignment = .Left
        descriptionLabel.text = NSLocalizedString("No descripton avalaible", comment: "")
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = UIFont.tradeGothicLTWithSize(10.0)
        descriptionLabel.textColor = UIColor.scorpionColor()
        
        return descriptionLabel
    }()
    
    /**
     Image View with the comic image.
     */
    var comicImageView: UIImageView = {
        
        let comicImageView: UIImageView = UIImageView.newAutoLayoutView()
        
        comicImageView.image = UIImage(named: "icon-cell-placeholder")
        comicImageView.layer.borderWidth = 0.0;
        comicImageView.layer.cornerRadius = 14.0;
        
        return comicImageView
    }()

    /**
     Separation line between cells.
     */
    private var separationLine: UIView = {
        
        let separationLine = UIView.newAutoLayoutView()
        
        separationLine.backgroundColor = UIColor.altoColor()
        
        return separationLine
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCellStyle,reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(comicImageView)
        contentView.addSubview(separationLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        
        comicImageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        comicImageView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10.0)
        comicImageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        comicImageView.autoSetDimension(.Width, toSize: 100.0)
        
        /*-------------------*/
        
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10.0)
        titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: comicImageView, withOffset: 10.0)
        titleLabel.autoSetDimension(.Height, toSize: 30.0)
        titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        
        /*-------------------*/
        
        descriptionLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 5.0)
        descriptionLabel.autoPinEdge(.Left, toEdge: .Right, ofView: comicImageView, withOffset: 10.0)
        descriptionLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        
        /*-------------------*/
        
        separationLine.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        separationLine.autoPinEdgeToSuperviewEdge(.Bottom)
        separationLine.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        separationLine.autoSetDimension(.Height, toSize: 0.5)
        
        /*-------------------*/
        
        super.updateConstraints()
    }
    
    //MARK: - Configure
    
    /**
     Configures the cell with a given Comic object.
     
     - parameter comic: the comic to be shown in the cell.
     */
    func configureWithComic(comic: Comic) {
        
        self.comic = comic

        titleLabel.text = comic.title
        
        if let comicDescription = comic.comicDescription {
            
            if comicDescription.characters.count > 0 {
                
                descriptionLabel.text = comicDescription
            }
        }

    }

    
    //MARK: - PrepareForReuse
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = NSLocalizedString("No descripton avalaible", comment: "")
        comicImageView.image = UIImage(named: "icon-cell-placeholder")
        comic = nil
    }
}

//
//  sbComicDetailController.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicDetailController: UIViewController
{
    // MARK: - Property(s)
    
    private(set) lazy var imageService: ImageService =
    { [unowned self] in
        
        let anObject = ImageService()
        anObject.session = URLSession.shared
        return anObject
    }()
    
    var comic: Comic? /* All a bit rushed and messy. */
    {
        didSet
        {
            if let controller = self.parent,
                self.view.superview == nil,
                let comic = comic
            {
                guard let url = URL(string: comic.cover),
                    let comicDetailView = self.view as? ComicDetailView else
                { return }
                
                controller.view.addSubview(comicDetailView)
                comicDetailView.setActivity(.loading, animated: true)
                
                UIView.animate(withDuration: 0.3)
                { comicDetailView.backroundView.alpha = 0.8 }
                
                self.imageService.resource(URLRequest(url: url))
                { (image, error) in
                    
                    DispatchQueue.main.async
                    {
                        comicDetailView.setActivity(.none, animated: true)
                        comicDetailView.imageView.image = image
                    }
                }
            }
            else
            {
                guard let comicDetailView = self.view as? ComicDetailView else
                { return }
                
                UIView.animate(withDuration: 0.3,
                               animations: {
                                
                                comicDetailView.backroundView.alpha = 0.0
                                comicDetailView.imageView.alpha = 0.0
                },
                               completion: { finished in
                                
                                if self.view.superview != nil
                                { self.view.removeFromSuperview() }
                })
            }
        }
    }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        self.viewRespectsSystemMinimumLayoutMargins = false
        
        self.view = ComicDetailView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.clear
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(callback(_:)))
        self.view.addGestureRecognizer(gesture)
    }
}

// MARK: - Action(s)
extension ComicDetailController
{
    @IBAction func callback(_ gesture: UILongPressGestureRecognizer)
    { self.comic = nil }
}


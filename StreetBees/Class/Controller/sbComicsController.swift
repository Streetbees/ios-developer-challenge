//
//  sbComicsController.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ComicsController: UIViewController
{
    // MARK: - Property(s)
    
    private(set) lazy var comics: APIComics =
    { [unowned self] in
        
        let anObject = APIComics()
        return anObject
    }()
    
    private(set) lazy var detailController: ComicDetailController =
    { [unowned self] in
        
        let anObject = ComicDetailController(nibName: nil, bundle: nil)
        
        self.addChildViewController(anObject)
        return anObject
    }()
    
    var dataSource: ComicsDataSource?
    {
        didSet
        {
            if let comicsView = self.view as? ComicsView
            {
                dataSource?.register(comicsView.collectionView)
                comicsView.collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Cleaning Up
    
    deinit
    { NotificationCenter.default.removeObserver(self) }
    
    
    // MARK: - Property Override(s)
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    { return .lightContent }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        self.view = ComicsView(frame: UIScreen.main.bounds)
        self.viewRespectsSystemMinimumLayoutMargins = false
        
        NotificationCenter.default.addObserver(forName: SBDataSourceDidSelectNotification,
                                               object: nil,
                                               queue: nil,
                                               using: notification(_:))
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        guard let comicsView = self.view as? ComicsView else
        { return }
        
        comicsView.setActivity(.loading, animated: true)
         
        if let path = Bundle.main.path(forResource: "comics", ofType: "json"),
            let jsonObject = URLQueryItem.load(contentsOfFile: path)
        {
            self.comics.fetch(URLQueryItem.compile(jsonObject: jsonObject),
                              cachePolicy: .reloadIgnoringLocalCacheData)
            { results in
                
                DispatchQueue.main.async
                {
                    comicsView.setActivity(.none, animated: true)
                    
                    let section = ComicsDataSourceSection(with: results)
                    self.dataSource = ComicsDataSource(with: [section])
                }
            }
        }
    }
}

// MARK: - Notification Support
extension ComicsController
{
    func notification(_ notification: Notification) -> Void
    {
        guard let comic = notification.object as? Comic else
        { return }
        
        self.detailController.comic = comic
    }
}


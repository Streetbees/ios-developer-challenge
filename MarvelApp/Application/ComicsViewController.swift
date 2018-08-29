//
//  ComicsViewController.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import UIKit

class ComicsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var emptyDataSetView: UIView!
    
    private var viewModel: ComicViewModel?
    private static let reuseIdentifier: String = "comicCell"
    private static let comicDetailSegueIdentifier: String = "showComicDetail"
    
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ComicsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.addSubview(refreshControl)
        self.collectionView.backgroundView = emptyDataSetView
    
        viewModel = ComicViewModel(service: MarvelService(api: AlamofireMarvelAPI()), repository: RMUseCaseProvider().makeComicUseCase())
        viewModel?.getComics(offset: 0, completionHandler: { error in
            self.collectionView.backgroundView = nil
            self.collectionView.reloadData()
            if error != nil {
                print(error!)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshComics(completionHandler: { error in
            self.refreshControl.endRefreshing()
        })
    }
    
    private func refreshComics(completionHandler: @escaping (_ error: Error?) -> Void) {
        viewModel?.getComics(offset: 0, completionHandler: { error in
            self.collectionView.reloadData()
            completionHandler(error)
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ComicsViewController.comicDetailSegueIdentifier {
            if let detailNavigationViewController = segue.destination as? UINavigationController {
                if let detailViewController = detailNavigationViewController.topViewController as? ComicDetailViewController {
                    
                    guard let indexPath = self.collectionView.indexPath(for: sender as! ComicCollectionViewCell) else {
                        return
                    }
                    
                    detailViewController.comic = viewModel?.comicAtIndex(index: indexPath.row)
                }
            }
        }
    }
}

extension ComicsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let numberOfItems = viewModel?.numberOfComics() ?? 0
        
        if numberOfItems > 0 {
            self.collectionView.backgroundView = nil
        }
        
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: ComicCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicsViewController.reuseIdentifier, for: indexPath) as! ComicCollectionViewCell
        
        if let comic = viewModel?.comicAtIndex(index: indexPath.row) {
            cell.comicImage.download(image: comic.thumbnail.buildString(size: .portrait_fantastic))
            cell.comicTitle.text = comic.title
        }
        
        return cell
    }
}

extension ComicsViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        if !viewModel.isFetching {
            guard let lastIndexPath = indexPaths.last else {
                return
            }
            
            if Double(lastIndexPath.row) / Double(viewModel.numberOfComics()) >= 0.4 {
                viewModel.getComics(offset: lastIndexPath.row) { error in
                    collectionView.reloadData()
                    if error != nil {
                        print(error!)
                    }
                }
            }
        }
    }
}

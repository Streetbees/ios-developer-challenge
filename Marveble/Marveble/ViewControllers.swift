//
//  ViewControllers.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 25/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import UIKit
import Nuke
import Alertable


class MainViewController: UICollectionViewController, ApocalypseDelegate
{
    //MARK: View Controller Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    //MARK: Collection View Controller Data Source
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apocalypse.marveler.comics?.count ?? 0
    }
    
    private static let mainCellId = "MainCell"
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MainViewController.mainCellId, forIndexPath: indexPath)
        
        if let mainCell = cell as? MainCell, let comic = self.apocalypse.marveler.comics?[indexPath.row] {
            mainCell.comic = comic
        }
        
        return cell
    }
    
    //MARK: Collection View Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: Scroll View Delegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        self.loadData()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        guard !decelerate else { return }
        self.loadData()
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        self.loadData()
    }
    
    //MARK: Apocalypse
    private(set) lazy var apocalypse: Apocalypse<MainViewController> = Apocalypse(delegate: self)
    
    private func loadData()
    {
        let visibleCells = self.collectionView?.indexPathsForVisibleItems() ?? []
        let start = visibleCells.first ?? NSIndexPath(forItem: 0, inSection: 0)
        let end = visibleCells.last ?? NSIndexPath(forItem: 0, inSection: 0)
        self.apocalypse.loadEverything(withStartingIndex: start, andEndIndex: end)
    }
    
    //Delegate
    func didFinishLoadingEverything(errorMessage: String?) {
        if let message = errorMessage {
            Alert(message, "Marveble", self).show(self)
        }
    }
    
    func didUpdateComic(comic: Comic) {
        if let cell = self.findCell(comic) {
            cell.comic = comic
        }
    }
    
    private func findCell(forComic: Comic) -> MainCell?
    {
        guard let cells = self.collectionView?.visibleCells() else { return nil }
        for cell in cells {
            if let mainCell = cell as? MainCell, let comic = mainCell.comic {
                if comic == forComic {
                    return mainCell
                }
            }
        }
        return nil
    }
    
    //MARK: UI Loader
    @IBOutlet weak var spinningThing: UIActivityIndicatorView?
    
    func didChangeLoadingStatus(loading: Bool) {
        
    }
}


class InfoViewController: UIViewController
{
    
}


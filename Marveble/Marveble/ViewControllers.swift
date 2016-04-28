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
import Permissionable
import Defines


class MainViewController: UICollectionViewController, ApocalypseDelegate, Alertable, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet var infoBarButtonItem: UIBarButtonItem!
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.alerting && !self.pickingImage {
            self.loadData()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(nil) { [weak self] (ctx: UIViewControllerTransitionCoordinatorContext) in
            self?.loadData()
        }
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: Collection View Controller Data Source
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.apocalypse.marveler.totalComics
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
    private var currentComic: Comic?
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.currentComic = self.apocalypse.marveler.comics?[indexPath.row]
        
        self.pickingImage = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        func present() {
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        if Defines.Device.IsSimulator {
            Permissions.Photos.request(self) { (success) in
                if success {
                    imagePicker.sourceType = .PhotoLibrary
                    present()
                }
            }
            return
        }
        
        let cameraAction = Alert.Action(title: "Camera", style: nil, handler: { [unowned self] (action) -> Void in
            Permissions.Camera.request(self) { (success) in
                imagePicker.sourceType = .Camera
                present()
            }
        })
        let photoAction = Alert.Action(title: "Photo Library", style: nil, handler: { [unowned self] (action) -> Void in
            Permissions.Photos.request(self) { (success) in
                imagePicker.sourceType = .PhotoLibrary
                present()
            }
        })
        let cancelAction = Alert.Action(title: "Cancel", style: .Cancel) { (action) in
            //Noop
        }
        self.alert(this: Alert("Where would you like to pick an image from?", nil, self, [cameraAction, photoAction, cancelAction], .ActionSheet))
    }
    
    //MARK: Scroll View Delegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.loadData()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        self.loadData()
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadData()
    }
    
    //MARK: Image Picker Delegate
    private var pickingImage = false
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true) { [unowned self] _ in
            self.pickingImage = false
            guard let current = self.currentComic else { return }
            self.currentComic = nil
            func go() {
                self.loading = true
                self.apocalypse.uploadImage(image, toComic: current)
            }
            if !self.apocalypse.dropboxer.autorised {
                self.apocalypse.dropboxer.authorise(self) { (success) in
                    if success {
                        go()
                    }
                }
                return
            }
            go()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true) { [unowned self] _ in
            self.pickingImage = false
        }
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
            self.alert(this: Alert(message, "Marveble", self))
            self.collectionView?.reloadData()
            return
        }
        
        if let visibleCells = self.collectionView?.visibleCells() {
            if visibleCells.isEmpty {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func didFinishUploadingPhoto(forComic: Comic) {
        self.loading = false
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


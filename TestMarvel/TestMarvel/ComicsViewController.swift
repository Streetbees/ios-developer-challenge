//
//  ViewController.swift
//  TestMarvel
//
//  Copyright © 2016 agit. All rights reserved.
//

import UIKit
import Gloss
import RxSwift
import UIScrollView_InfiniteScroll
import AVFoundation

class ComicsViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let disposeBag = DisposeBag()
    var drive: DriveBase = DriveDropbox()
    let store = ComicsStore()
    var bottomState: BottomState = .Retrieving {
        didSet {
            var value = ""
            
            switch bottomState {
            case .Retrieving:
                value = "(Retrieving...)"
                
            case .NeedsLogin:
                value = "Tap here to Link to \(self.drive.name())"

            case .AlreadyLoggedIn:
                value = "Linked to \(self.drive.name())"
                
            case .Downloading(let pos):
                value = "Downloading (\(Int(100*pos))%)"
            }
            
            self.bottomItem.title = value
        }
    }
    private var isDownloading: Bool = false {
        didSet {
            if isDownloading {
                self.bottomState = .Downloading(0)
                
            } else {
                self.bottomState = stateFromDrive()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomItem: UIBarButtonItem!
    
    @IBAction func onTapBottomItem(sender: AnyObject) {
        switch self.bottomState {
        case .NeedsLogin:
            self.drive.doLogin(self)
            
        case .AlreadyLoggedIn:
            let alert = UIAlertController.init(title: self.drive.name(), message: "You are already logged in", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "Unlink", style: .Default, handler: {
                [weak self] (action) in
                if let selfWeak = self {
                    selfWeak.drive.unlink()
                    selfWeak.bottomState = selfWeak.stateFromDrive()
                }
            }))
            alert.addAction(UIAlertAction.init(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
        case .Retrieving:
            break
            
        case .Downloading(_):
            break
        }
    }
    
    func stateFromDrive() -> BottomState {
        return self.drive.alreadyLoggedIn() ? .AlreadyLoggedIn : .NeedsLogin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Marvel Comics"
        
        //prepare
        self.store.drive = self.drive
        
        //
        self.collectionView.dataSource = store
        self.collectionView.delegate = self
        
        self.collectionView.infiniteScrollIndicatorStyle = .Gray
        self.collectionView.addInfiniteScrollWithHandler({
            [weak self] (scrollView) in
            guard let selfWeak = self else {
                return
            }
            
            selfWeak.store.getMoreComics()
        })

        store.isRetrievingComics.asObservable().subscribeNext {
            [weak self] (next:Bool) in
            guard let selfWeak = self else {
                return
            }

            if next {
                selfWeak.bottomState = .Retrieving
                
            } else {
                selfWeak.bottomState = selfWeak.stateFromDrive()
            }
        }
        .addDisposableTo(disposeBag)
        
        //if comics change => refresh collection
        store.comics.asObservable().subscribeNext {
            [weak self] (next:[Comic]) in
            guard let selfWeak = self else {
                return
            }
            
            selfWeak.collectionView.reloadData()
            selfWeak.collectionView.finishInfiniteScroll()
        }
        .addDisposableTo(disposeBag)
        
        store.total.asObservable().subscribeNext {
            [weak self] (next:Int) in
            guard let selfWeak = self else {
                return
            }

            selfWeak.title = "Marvel Comics"+(next<=0 ? "" : (" ["+String(next)+"]"))
        }
        .addDisposableTo(disposeBag)

        //get first list of comics
        store.reset()
        store.getMoreComics()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        //center cells if there is to much space left (like in iPhone "plus")
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width
        let collectionViewWidth = collectionView.bounds.size.width
        let cellCount = Int(collectionViewWidth/cellWidth)
        
        let totalCellWidth = CGFloat(cellCount) * cellWidth
        let totalCellSpacing = cellSpacing * CGFloat(cellCount - 1)
        
        let totalCellsWidth = totalCellWidth + totalCellSpacing
        
        let edgeInsets = (collectionViewWidth - totalCellsWidth) / 2.0
        
        return edgeInsets > 0 ? UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets) : UIEdgeInsetsMake(0, cellSpacing, 0, cellSpacing)
    }
    
    func driveLoggedIn() {
        self.isDownloading = true
        
        self.drive.listFiles({
            [weak self] (list) in
            if let selfWeak = self {
                selfWeak.downloadFiles(list)
            }
            
            }) { [weak self] (error) in
                if let selfWeak = self {
                    selfWeak.isDownloading = false
                }
                //TODO retry?
        }
    }
    
    func downloadFiles(list:[String]) {
        //iterate inside [list] to retrieve each file
        let tsid = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        downloadOneFile(list, index: 0, tsid: tsid)
    }
    
    func downloadOneFile(list:[String], index: Int, tsid: UIBackgroundTaskIdentifier) {
        if index>=list.count || list.count==0 {
            //finished
            UIApplication.sharedApplication().endBackgroundTask(tsid)
            
            self.isDownloading = false
            //refresh collection, so it takes the images from disk
            self.collectionView.reloadData()
            return
        }
        
        //update %
        self.bottomState = .Downloading(Double(index)/Double(list.count))
        
        //
        self.drive.loadFile(list[index], onSuccess: {
            [weak self] () in
            if let selfWeak = self {
                selfWeak.downloadOneFile(list, index: index+1, tsid: tsid)
            }
            
            }) {
                //TODO retry?
                [weak self] (error) in
                if let selfWeak = self {
                    selfWeak.downloadOneFile(list, index: index+1, tsid: tsid)
                }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !self.drive.alreadyLoggedIn() {
            let alert = UIAlertController.init(title: "Take Photo", message: "You need to be linked to \(self.drive.name()) first", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "Done", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        //take photo
        let comic = self.store.comics.value[indexPath.row]

        if comic.isUploading {
            let alert = UIAlertController.init(title: "Take Photo", message: "Already uploading to \(self.drive.name())!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "Done", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            takePhoto(comic)
            
        } else if let comicId = comic.comicId {
            //no camera => use Tom Hanks photo
            saveImageForComic(comic, imageOri: drawImagesAndText(String(comicId)))
            
            let alert = UIAlertController.init(title: "Take Photo", message: "There is no camera in this device, using Tom Hanks photo! :)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "Done", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Camera Picker
    var imagePicker: UIImagePickerController!
    var photoForComic: Comic?
    
    func takePhoto(comic:Comic) {
        if !checkCamera() {
            return
        }
        
        self.photoForComic = comic
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func checkCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == .Denied {
            alertToEncourageCameraAccessInitially()
            return false
            
        } else {
            return true
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(title: "IMPORTANT", message: "Camera access required", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, comic = self.photoForComic {
            saveImageForComic(comic, imageOri: image)
        }
    }
    
    //End Camera Picker
    
    func drawImagesAndText(text: String) -> UIImage {
        let tomImage = UIImage.init(named: "tomhanks")!
        
        UIGraphicsBeginImageContextWithOptions(tomImage.size, false, 0)
        
        tomImage.drawAtPoint(CGPoint(x: 0, y: 0))

        text.drawWithRect(CGRect(x: 32, y: 32, width: tomImage.size.width-32, height: 25), options: .UsesLineFragmentOrigin, attributes: nil, context: nil)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    private func resizeImage(image: UIImage) -> UIImage {
        let maxSize: CGFloat = 300.0
        var size: CGSize?
        
        size = CGSizeMake(maxSize, (maxSize / image.size.width) * image.size.height)
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size!, !hasAlpha, scale)
        
        let rect = CGRect(origin: CGPointZero, size: size!)
        UIRectClip(rect)
        image.drawInRect(rect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func saveImageForComic(comic: Comic, imageOri: UIImage) {
        if let comicId = comic.comicId {
            var image = imageOri
            if image.size.width > 300 {
                image = self.resizeImage(image)
            }
            
            if let data: NSData = UIImageJPEGRepresentation(image, 1.0) {
                let tsid = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
                
                comic.isUploading = true
                
                //local
                if !drive.fileToDisk(String(comicId), content: data) {
                    //TODO log error
                }
                self.collectionView.reloadData()
                
                //drive
                drive.saveFile(String(comicId), content: data, onSuccess: {
                    () in
                    comic.isUploading = false
                    
                    UIApplication.sharedApplication().endBackgroundTask(tsid)
                    
                    }, onError: {
                        (error) in
                        comic.isUploading = false
                        
                        UIApplication.sharedApplication().endBackgroundTask(tsid)
                    }, onProgress: {
                        (pos) in
                        comic.uploadProgress.value = pos
                })
                
                //TODO upload files if they weren't upload before
            }
        }
    }
    
    func driveAppDelegateURL(url:NSURL) {
        self.drive.handleURL(url, onSuccess: {
            [weak self] (token) in
            if let selfWeak = self {
                selfWeak.driveLoggedIn()
            }
            
            }, onError: {
            (description) in
                //
        })
    }
}


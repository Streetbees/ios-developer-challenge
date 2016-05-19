//
//  ComicsFeedViewController.swift
//  Marvel
//
//  Created by Gabriel Massana on 17/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreDataFullStack
import PureLayout
import MobileCoreServices

let NavigationBarHeight: CGFloat = 64.0

class ComicsFeedViewController: UIViewController {

    //MARK: - Accessors

    /**
     Tapped comic object to add personal photo.
     */
    var comic: Comic?
    
    lazy var imagePicker: UIImagePickerController = {
        
        var imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType =  UIImagePickerControllerSourceType.Camera
        imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = .FullScreen
        
        return imagePicker
    }()
    
    /**
     Table view to display data.
     */
    lazy var tableView: MarvelTableView = {
        
        let tableView: MarvelTableView = MarvelTableView.newAutoLayoutView()
        
        tableView.emptyView = self.emptyView

        return tableView
    }()
    
    /**
     Empty View to be shown when no data in the Table View.
     */
    lazy var emptyView: ComicFeedEmptyView = {
        
        let emptyView: ComicFeedEmptyView = ComicFeedEmptyView(frame: CGRect.init(x: 0.0, y: 0.0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: CGRectGetHeight(UIScreen.mainScreen().bounds) - NavigationBarHeight))
        
        return emptyView
    }()
    
    /**
     Adapter to  manage the common logic and data of the tableView.
     */
    lazy var adapter: ComicsFeedAdapter = {
        
        let adapter = ComicsFeedAdapter()
        
        adapter.delegate = self
        
        return adapter
    }()
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "Marvel Comics"
        
        /*-------------------*/
        
        view.addSubview(tableView)
        
        adapter.tableView = tableView
        
        /*-------------------*/
        
        adapter.paginate()
        
        /*-------------------*/
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dropboxLinked), name: DropboxLinked, object: nil)
        
        /*-------------------*/
        
        updateViewConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        /*-------------------*/
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: - OpenCamera

    /**
     Opens the camera to capture a new comic image.
     */
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
        }
        else
        {
            print("No camera on Simulator!")
        }
    }
    
    //MARK: - Dropbox

    /**
     Call to upload image to Dropbox
     
     - parameter comic: comic object related to the image to upload to Dropbox.
     */
    func uploadImageToDropbox(comic: Comic) {
        
        if !DBSession.sharedSession().isLinked() {
        
            DBSession.sharedSession().linkFromController(self)
        }
        else {
            
            DropboxService.sharedInstance.uploadImage(comic.comicID!)
        }
    }

    func dropboxLinked() {
        
        if let comic = self.comic {
            
            DropboxService.sharedInstance.uploadImage(comic.comicID!)
        }
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension ComicsFeedViewController : ComicsFeedAdapterDelegate {
    
    func didSelectComic(comic: Comic) {
    
        self.comic = comic
        
        openCamera()
    }
}

extension ComicsFeedViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeImage as String {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let comic = self.comic {
                
                MediaAPIManager.saveImage(image, comic: comic)
                
                uploadImageToDropbox(comic)
            }
         }
    }
}

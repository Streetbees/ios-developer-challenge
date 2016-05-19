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
    
    /**
     Table view to display data.
     */
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView.newAutoLayoutView()
        
        return tableView
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
        
        /*-------------------*/
        
        view.addSubview(tableView)
        
        adapter.tableView = tableView
        
        /*-------------------*/
        
        adapter.paginate()
        
        /*-------------------*/
        
        updateViewConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        /*-------------------*/
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =  UIImagePickerControllerSourceType.Camera
            imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ComicsFeedViewController : ComicsFeedAdapterDelegate {
    
    func didSelectComic(comic: Comic) {
    
        // Open Camera
        print("Open Camera")
        
        // Add Spinner
        // Add alert if no Camera allowed
        
        self.comic = comic
        
        openCamera()
    }
}

extension ComicsFeedViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeImage as String {
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            print(image)
            
            // Operation save image and update Comic object
         }
    }
}

extension ComicsFeedViewController : UINavigationControllerDelegate {
    
}

//
//  ComicViewController.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import UIKit
import SDWebImage

class ComicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var onSaleDate: UILabel!
    @IBOutlet weak var coverThumbnail: UIImageView!
    @IBOutlet weak var changeCoverButton: UIButton!
    
    var marvelThumbnail: UIImage?
    var dropboxThumbnail: UIImage?
    var tempPhoto: UIImage?
    var removedDropboxThumbnail: Bool = false
    
    var currentComic: Comic?
    var imagePicker: UIImagePickerController!
    var dropBoxController = DropBoxController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.refreshDisplay()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var hasImageUploadCanceled = false
    // Mark: Take cover photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        coverThumbnail.image = image
        
        
        let alertController  = UIAlertController(title: "", message: "Saving (0%)", preferredStyle: .Alert)
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(50, 10, 37, 37)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        
        
        alertController.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
            self.hasImageUploadCanceled = true
        }))
        
        // Save the image to DropBox
        if let coverThumbnailImage = image, comic = currentComic {
            hasImageUploadCanceled = false
            dropBoxController.uploadCoverImage(comic, image: coverThumbnailImage , progress: { (progress) in
                    log.debug("\(progress)")
                dispatch_async(dispatch_get_main_queue(), {
                    let progressInt:Int = Int(progress*100)
                    alertController.message = "Saving to Dropbox (\(progressInt))%"
                })
                }, completion: { (error) in
                    if error == nil && !self.hasImageUploadCanceled {
                        SDImageCache.sharedImageCache().storeImage(coverThumbnailImage, forKey: comic.dropboxFileName, toDisk: true)
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    }
            })

        }
            imagePicker.dismissViewControllerAnimated(true) {
            self.presentViewController(alertController, animated: true) {
                
            }
        }
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showImagePicker() {
        imagePicker =  UIImagePickerController()
        // Hide camera flip, so only front cam available
        imagePicker.delegate = self
        
        // Check if camera is available, if so then use it. Otherwise, fallback to library
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == true {
            imagePicker.sourceType = .Camera
            imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
        }
        else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        showImagePicker()
    }
    
    
    // Mark: UI stuff
    func refreshDisplay ()
    {
        self.titleLabel.text = currentComic?.title
        self.summaryLabel.text = currentComic?.description
        self.navigationItem.title = "Comic"
        
        // If we have image path, then replace placeholder image
        if let currentComic = currentComic {
            if let imagePath = currentComic.imagePath, imageExtension = currentComic.imageExtension {
                let imageURL = "\(imagePath).\(imageExtension)"
                log.debug("imageURL: \(imageURL)")
                
                MarvelAPI.sharedInstance.replaceImageWithURLString(imageURL, comic: currentComic, imageToReplace: self.coverThumbnail, placeholderImage: UIImage(named: "marvel")!)
            }
        }
        
    }
    
    
    func choseImageToDisplay() -> UIImage {
        let image: UIImage
        
        if let dropboxImage = dropboxThumbnail {
            image = dropboxImage
        } else if let marvelImage = marvelThumbnail {
            image = marvelImage
        } else {
            //image = UIImage.coverPlaceholder()
            image = UIImage()
        }
        
        return image
    }
    
}

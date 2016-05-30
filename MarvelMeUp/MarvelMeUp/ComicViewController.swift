//
//  ComicViewController.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/24/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ComicViewController: UIViewController {

    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var resetButton: UIButton!

    var comic: Comic!
    lazy var dropboxManager = DropboxManager()
    var selfieShot = false
    var delegate: CoverUpdateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if dropboxManager.connected {
            dropboxManager.comicCoverExists(comic.id) { replaced in
                if replaced {
                    self.loadImageFromDropbox()
                    self.resetButton.hidden = false
                } else {
                    self.loadImage()
                    self.resetButton.hidden = true
                }
            }
        } else {
            self.loadImage()
            self.resetButton.hidden = true
        }
    }

    func loadImage() {
        if let image = comic.imageURL.cachedImage {
            comicImageView.image = image
            comicImageView.alpha = 1
        } else {
            comicImageView.alpha = 0
            comic.imageURL.fetchImage { [unowned self] image in
                self.comicImageView.image = image
                UIView.animateWithDuration(0.3) {
                    self.comicImageView.alpha = 1
                }
            }
        }
    }

    @IBAction func shootPhotoButtonPressed(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let photoPicker: UIImagePickerController = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.allowsEditing = true
            photoPicker.sourceType = .Camera
            photoPicker.cameraDevice = .Front
            presentViewController(photoPicker, animated: true, completion: nil)
        }
    }

    @IBAction func resetButtonTapped(sender: AnyObject) {
        dropboxManager.deleteImage(comic.id) { [weak self] (deleted, error) in
            if deleted {
                NSNotificationCenter.defaultCenter().postNotificationName("CoverSaved", object: nil)
                if let weakSelf = self {
                    weakSelf.loadImage()
                    weakSelf.comic.replaced = false
                    weakSelf.delegate?.coverDidUpdate()
                }
            }
        }
    }

}

extension ComicViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: { [unowned self] (_) in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.comicImageView.image = image
                self.selfieShot = true
                
                if !self.dropboxManager.connected {
                    let message = "If you want to save the new cover to Dropbox, you have to authorize the app"
                    let alertController = UIAlertController(title: "Dropbox not connected", message: message, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
                    let authorizeAction = UIAlertAction(title: "Authorize", style: .Default) { (_) in
                        Dropbox.authorizeFromController(self)


                        let newAlert = UIAlertController(title: "Save", message: "Save photo to dropbox?", preferredStyle: .Alert)
                        let cAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
                        let sAction = UIAlertAction(title: "Save", style: .Default) { (_) in
                            self.dropboxManager = DropboxManager()
                            self.savePhotoToDropbox()
                        }
                        newAlert.addAction(cAction)
                        newAlert.addAction(sAction)
                        self.presentViewController(newAlert, animated: false, completion: nil)


                    }
                    alertController.addAction(cancelAction)
                    alertController.addAction(authorizeAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    self.savePhotoToDropbox()
                }
            }
        })
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func savePhotoToDropbox() {
        if let image = comicImageView.image {
            dropboxManager.saveImage(comic.id, image: image) { [weak self] saved, error in
                if saved {
                    NSNotificationCenter.defaultCenter().postNotificationName("CoverSaved", object: nil)
                    if self != nil {
                        self!.comic.replaced = true
                        self!.delegate?.coverDidUpdate()
                    }
                }
            }
        }
    }

    func loadImageFromDropbox() {
        SwiftSpinner.show("Loading cover from Dropbox")
        dropboxManager.loadImage(comic.id, thumb: false) { imageData, error in
            if let imageData = imageData {
                self.comicImageView.image = UIImage(data: imageData)
            } else {
                print(error?.localizedDescription)
            }
            SwiftSpinner.hide()
        }
    }

}


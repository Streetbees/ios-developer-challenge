import UIKit
import RxSwift
import RxCocoa
import AutoLayoutPlus
import RxMediaPicker
import AVFoundation
import SwiftyDropbox

class ComicDetailsViewController: UIViewController {
    
    let comic: Comic
    let disposeBag = DisposeBag()
    let cellIdentifier = "cellIdentifier"
    
    var picker: RxMediaPicker?
    var tempPhoto: UIImage?
    var dropboxPhotoWasRemoved: Bool = false
    
    var hasDropboxThumbnail: Bool {
        if let _ = comic.dropboxThumbnail {
            return true
        }
        return false
    }
    
    var hasTempPhoto: Bool {
        if let _ = tempPhoto {
            return true
        }
        return false
    }
    
    var dropboxLinked: Bool {
        return ImageLoaderService.service.dropboxLinked
    }
    
    lazy var detailsTableView: UITableView  = self.makeDetailsTableView()
    lazy var comicThumbnail: UIImageView    = self.makeComicThumbnail()
    lazy var titleLabel: UILabel            = self.makeTitleLabel()
    lazy var removeButton: UIButton         = UIButton.circularButton(self, action: #selector(deleteDropboxImage), icon: UIImage.iconBin())
    lazy var cameraButton: UIButton         = UIButton.circularButton(self, action: #selector(selectCustomImage), icon: UIImage.iconCamera())
    lazy var saveButton: UIBarButtonItem    = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(saveChanges))
    lazy var progress: UIProgressView       = self.makeProgressView()
    
    init(comic: Comic) {
        self.comic = comic
        
        super.init(nibName: .None, bundle: .None)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupSubviews()
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        picker = RxMediaPicker(delegate: self)
        
        edgesForExtendedLayout = .None
        
        if dropboxLinked {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            removeButton.hidden = true
            cameraButton.hidden = true
        }
        
        titleLabel.text = comic.title
        comicThumbnail.image = defineImageToDisplay(comic)
        
        updateUI()
    }
    
    func deleteDropboxImage() {
        if let _ = comic.dropboxThumbnail {
            comicThumbnail.image = comic.thumbnail ?? UIImage.coverPlaceholder()
            dropboxPhotoWasRemoved = true
        } else {
            tempPhoto = .None
        }
        
        updateUI()
    }
    
    func selectCustomImage() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { granted in
            if granted {
                self.launchCameraPicker()
            } else {
                self.launchPermissionsAlert()
            }
        }
    }
    
    func launchCameraPicker() {
        picker?.takePhoto(device: .Front, editable: true)
            .observeOn(MainScheduler.instance)
            .subscribeNext{ (image, editedImage) in
                if let img = editedImage {
                    self.comicThumbnail.image = img
                    self.tempPhoto = img
                    self.updateUI()
                }
                
            }.addDisposableTo(disposeBag)
    }
    
    func launchPermissionsAlert() {
        let alert = UIAlertController(title: "Camera access required", message: "Please enable Camera Access in Settings / Privacy / Camera", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: .None))
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: .None)
        }
    }
    
    func saveChanges() {
        navigationItem.hidesBackButton = true
        progress.hidden = false
        
        /*
        viewModel.saveChanges(tempPhoto!, progress: { progress in
            print("Upload progress: \(progress)")
        }, completion: { error in
            print("Save changes completed")
        })
        */
        
        //upload or delete file on dropbox
    }
    
    func updateUI() {
        let existingChanges = hasTempPhoto || dropboxPhotoWasRemoved
        
        saveButton.enabled = existingChanges
        removeButton.hidden = !(existingChanges || hasDropboxThumbnail)
    }
    
    func defineImageToDisplay(comic: Comic) -> UIImage {
        let image: UIImage
        
        if let dropboxImage = comic.dropboxThumbnail {
            image = dropboxImage
        } else if let marvelImage = comic.thumbnail {
            image = marvelImage
        } else {
            image = UIImage.coverPlaceholder()
        }
        
        return image
    }
    
    func setSavingUI() {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activity)
        activity.startAnimating()
    }

}

extension ComicDetailsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = comic.description ?? "No description available for this comic."
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
}

extension ComicDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return titleLabel
    }
}

extension ComicDetailsViewController: RxMediaPickerDelegate {
    
    func presentPicker(picker: UIImagePickerController) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.presentViewController(picker, animated: true, completion: .None)
        }
    }
    
    func dismissPicker(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: .None)
    }
}

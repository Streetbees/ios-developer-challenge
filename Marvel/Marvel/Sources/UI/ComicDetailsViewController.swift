import UIKit
import RxSwift
import RxMediaPicker
import AVFoundation
import SwiftyDropbox

class ComicDetailsViewController: UIViewController {
    let comic: Comic
    let disposeBag = DisposeBag()
    let cellIdentifier = "cellIdentifier"
    
    var picker: RxMediaPicker?
    var tempPhoto: UIImage?
    var removedDropboxThumbnail: Bool = false
    
    var hasDropboxThumbnail: Bool { return comic.dropboxThumbnail != .None }
    var hasTempPhoto: Bool        { return tempPhoto != .None }
    var dropboxLinked: Bool       { return ImageLoaderService.service.dropboxLinked }
    
    lazy var detailsTableView: UITableView  = self.makeDetailsTableView()
    lazy var comicThumbnail: UIImageView    = self.makeComicThumbnail()
    lazy var titleLabel: UILabel            = self.makeTitleLabel()
    lazy var removeButton: UIButton         = self.makeCircularButton(self, action: #selector(deleteImagePressed), icon: UIImage.iconBin())
    lazy var cameraButton: UIButton         = self.makeCircularButton(self, action: #selector(selectImagePressed), icon: UIImage.iconCamera())
    lazy var saveButton: UIBarButtonItem    = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(saveChanges))
    lazy var progressBar: UIProgressView    = self.makeProgressBar()
    lazy var titleActivityIndicator: UIView = self.makeTitleActivityIndicator()
        
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
        comicThumbnail.image = defineImageToDisplay()
        
        refreshUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        silentNotification()
    }
    
    func deleteImagePressed() {
        
        if let _ = tempPhoto {
            tempPhoto = .None
            comicThumbnail.image = defineImageToDisplay()
        } else {
            comicThumbnail.image = comic.thumbnail ?? UIImage.coverPlaceholder()
            removedDropboxThumbnail = true
        }
        
        refreshUI()
    }
    
    func defineImageToDisplay() -> UIImage {
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
    
    func selectImagePressed() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { granted in
            if granted {
                self.launchCameraPicker()
            } else {
                self.launchPermissionsAlert()
            }
        }
    }
    
    func launchCameraPicker() {
        //picker?.selectImage(editable: true)
        picker?.takePhoto(device: .Front, editable: true)
            .observeOn(MainScheduler.instance)
            .subscribeNext{ (image, editedImage) in
                if let img = editedImage {
                    self.comicThumbnail.image = img
                    self.tempPhoto = img
                    self.refreshUI()
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
        setSaving()
        
        if let temp = tempPhoto {
            uploadNewCover(temp)
        } else if comic.dropboxThumbnail != .None && removedDropboxThumbnail {
            deleteDropboxThumbnail()
        }
    }
    
    func uploadNewCover(image: UIImage) {
        progressBar.setProgress(0, animated: false)
        progressBar.hidden = false
        
        ImageLoaderService.service.uploadImageForComic(comic, image: image, progress: { progress in
            dispatch_async(dispatch_get_main_queue(), { 
                self.progressBar.setProgress(progress, animated: true)
            })
        }, completion: { error in
            self.progressBar.hidden = true
            
            if let _ = error {
                self.showError("Failed to save changes")
            } else {
                self.comic.dropboxThumbnail = image
                self.tempPhoto = .None
                self.showSuccess("Changes saved successfuly")
            }

            self.endSaving()
        })
    }
    
    func deleteDropboxThumbnail() {
        ImageLoaderService.service.deleteImageForComic(comic) { error in
            
            if let _ = error {
                self.showError("Failed to save changes")
            } else {
                self.comic.dropboxThumbnail = .None
                self.removedDropboxThumbnail = false
                self.showSuccess("Changes saved successfuly")
            }
            
            self.endSaving()
        }
    }
    
    func refreshUI() {
        saveButton.enabled = hasTempPhoto || removedDropboxThumbnail
        
        let visible = (hasDropboxThumbnail && !removedDropboxThumbnail) || hasTempPhoto
        removeButton.hidden = !visible
    }
    
    func setSaving() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = .None
        
        showActivityIndicator()
        
        removeButton.enabled = false
        cameraButton.enabled = false
    }
    
    func endSaving() {
        hideActivityIndicator()
        
        navigationItem.hidesBackButton = false
        navigationItem.rightBarButtonItem = saveButton
        
        removeButton.enabled = true
        cameraButton.enabled = true
        
        refreshUI()
    }
    
    func showActivityIndicator() {
        navigationItem.titleView = titleActivityIndicator
    }
    
    func hideActivityIndicator() {
        navigationItem.titleView = .None
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

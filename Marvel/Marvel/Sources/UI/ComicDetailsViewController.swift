import UIKit
import RxSwift
import RxCocoa
import AutoLayoutPlus
import RxMediaPicker
import AVFoundation

private let cellIdentifier = "cellIdentifier"

class ComicDetailsViewController: UIViewController {
    
    let viewModel: ComicDetailsViewModel
    let disposeBag = DisposeBag()
    var picker: RxMediaPicker?
    
    lazy var detailsTableView: UITableView  = self.makeDetailsTableView()
    lazy var comicThumbnail: UIImageView    = self.makeComicThumbnail()
    
    init(viewModel: ComicDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .None, bundle: .None)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupSubviews()
        setupConstraints()
        
        view.backgroundColor = UIColor.whiteColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        picker = RxMediaPicker(delegate: self)
        
        edgesForExtendedLayout = .None
        
        setupBindings()
        viewModel.active = true
    }
    
    func setupSubviews() {
        view.addSubview(detailsTableView)
    }
    
    func setupConstraints() {
        let constraints = detailsTableView.likeParent()
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func makeDetailsTableView() -> UITableView {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        t.tableHeaderView = comicThumbnail
        
        t.rx_setDelegate(self)
            .addDisposableTo(disposeBag)
        
        return t
    }
    
    func makeComicThumbnail() -> UIImageView {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 300)
        let i = UIImageView(frame: frame)
        i.userInteractionEnabled = true
        i.contentMode = .ScaleAspectFit
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCustomImage)))
        
        return i
    }
    
    func setupBindings() {
        viewModel.title.subscribeNext { self.navigationItem.title = $0 }
            .addDisposableTo(disposeBag)
        
        viewModel.thumbnail
            .bindTo(comicThumbnail.rx_image)
            .addDisposableTo(disposeBag)
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
                self.comicThumbnail.image = editedImage
            }.addDisposableTo(disposeBag)
    }
    
    func launchPermissionsAlert() {
        let title = "Camera access required"
        let message = "Please enable Camera Access in Settings / Privacy / Camera"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: .None))
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: .None)
        }
    }
}

extension ComicDetailsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO: calculate description size
        return 100
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return comicTitleHeader
    }
    */
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

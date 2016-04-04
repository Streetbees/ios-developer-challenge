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
    lazy var titleLabel: UILabel            = self.makeTitleLabel()
    lazy var removeButton: UIButton         = UIButton.circularButton(self, action: #selector(deleteCustomImage), icon: UIImage.iconBin())
    lazy var cameraButton: UIButton         = UIButton.circularButton(self, action: #selector(selectCustomImage), icon: UIImage.iconCamera())
    
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
        
        navigationItem.title = "Comic Details"
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
        t.separatorStyle = .None
        t.rowHeight = UITableViewAutomaticDimension
        t.estimatedRowHeight = 100
        
        t.rx_setDelegate(self)
            .addDisposableTo(disposeBag)
        
        return t
    }
    
    func makeComicThumbnail() -> UIImageView {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 300)
        let i = UIImageView(frame: frame)
        i.userInteractionEnabled = true
        i.contentMode = .ScaleAspectFit
        i.backgroundColor = UIColor.blackColor()
        i.addSubview(removeButton)
        i.addSubview(cameraButton)
        
        let constraints = NSLayoutConstraint.withFormat([
            "V:[removeButton(==50)]-10-[cameraButton(==50)]-10-|",
            "H:[removeButton(==50)]-10-|",
            "H:[cameraButton(==50)]-10-|",
        ], views: ["removeButton": removeButton, "cameraButton": cameraButton])
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        return i
    }
    
    func makeTitleLabel() -> UILabel {
        let l = UILabel(frame: CGRect.zero)
        l.font = UIFont.marvelRegular(16)
        l.textAlignment = .Center
        l.numberOfLines = 2
        l.textColor = UIColor.whiteColor()
        l.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        
        return l
    }
    
    func setupBindings() {
        viewModel.title
            .bindTo(titleLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.thumbnail
            .bindTo(comicThumbnail.rx_image)
            .addDisposableTo(disposeBag)
        
        viewModel.details
            .bindTo(detailsTableView.rx_itemsWithCellIdentifier(cellIdentifier)) { (row, element, cell) in
                cell.textLabel?.text = element
                cell.textLabel?.numberOfLines = 0
            }
            .addDisposableTo(disposeBag)
    }
    
    func deleteCustomImage() {
        self.comicThumbnail.image = viewModel.model.thumbnail
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
                    ImageLoaderService.service.uploadImageForComic(self.viewModel.model, image: img)
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

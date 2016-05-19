//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift

public class ComicCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadParentView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    public var drive: DriveBase?
    private var observeUploadProgress: Disposable?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func prepareForReuse() {
        self.comic = nil
    }
    
    public var comic:Comic? {
        didSet {
            self.observeUploadProgress?.dispose()
            self.observeUploadProgress = nil

            //
            if let comic = comic, comicId = comic.comicId {
                
                self.observeUploadProgress = comic.uploadProgress.asObservable().subscribeNext {
                    [weak self] (pos) in
                    assert(NSThread.isMainThread())
                    
                    guard let selfWeak = self where pos > 0 else {
                        return
                    }
                    
                    if pos>=1.0 {
                        selfWeak.downloadParentView.hidden = true
                        return
                    }
                    
                    if selfWeak.downloadParentView.hidden {
                        selfWeak.downloadParentView.hidden = false
                    }
                    if selfWeak.progressLabel.text != "Uploading..." {
                       selfWeak.progressLabel.text = "Uploading..."
                    }
                    selfWeak.progressView.progress = Float(pos)
                }
                
                //shadow
                imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
                imageView.layer.shadowRadius = 3
                imageView.layer.shadowColor = UIColor.blackColor().CGColor
                imageView.layer.shadowOpacity = 1

                if let drive = self.drive {
                    if let data = drive.fileFromDisk(String(comicId)) {
                        if let img = UIImage(data: data) {
                            //is on disk... load directly and finish
                            imageView.image = img
                            return
                        }
                    }
                }
                
                let options: KingfisherOptionsInfo = [
                    .Transition(ImageTransition.Fade(1))
                ]
                
                let url = comic.thumbnailURLForScale(UIScreen.mainScreen().scale)
                
                if url=="" {
                    imageView.image = nil
                    
                } else {
                    let URL = NSURL(string: url)!
                    
                    //download image or use from cache
                    imageView.kf_setImageWithURL(URL, placeholderImage: nil, optionsInfo: options,
                        progressBlock: {
                            [weak self] (receivedSize, totalSize) -> () in
                            assert(NSThread.isMainThread())
                            
                            guard let selfWeak = self else {
                                return
                            }
                            
                            if selfWeak.downloadParentView.hidden {
                                selfWeak.downloadParentView.hidden = false
                            }
                            if selfWeak.progressLabel.text != "Downloading..." {
                                selfWeak.progressLabel.text = "Downloading..."
                            }
                            selfWeak.progressView.progress = totalSize<=0 ? Float(0) : Float(Float(receivedSize) / Float(totalSize))
                        },
                        completionHandler: {
                            [weak self] (image, error, cacheType, imageURL) -> () in
                            guard let selfWeak = self else {
                                return
                            }
                            
                            selfWeak.downloadParentView.hidden = true
                        })
                }
                
            } else {
                imageView.image = nil
            }
        }
    }
}

//
//  ComicCell.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire
import RxSwift
import RxCocoa
import SwiftyDropbox

class ComicCell: UITableViewCell {
    
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicNameLabel: UILabel!
    
    let reuseSignal = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.comicImageView.image = nil
        reuseSignal.onNext(true)
    }
    
    func updateCellWithComic(comic: MarvelComic) {
       self.comicNameLabel.text = comic.title
        
        guard let thumbnail = comic.thumbnail else {
            return
        }
        guard let localPath = thumbnail.localPath, localName = thumbnail.localName else {
            if let imageURL = thumbnail.imageURLString(.StandardMedium) {
                
                NetworkManager
                    .requestImage(imageURL)
                    .takeUntil(self.reuseSignal.asObservable())
                    .subscribeNext { [weak self] image in
                        self?.comicImageView.image = image
                    }
                    .addDisposableTo(disposeBag)
                
                return
            }
            return
        }
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory,
                                                                                       inDomain: .UserDomainMask,
                                                                                       appropriateForURL: nil,
                                                                                       create: true)
        let fileURL = documentDirectoryURL.URLByAppendingPathComponent(localName)
        var error : NSError?
        let fileExists = fileURL.checkResourceIsReachableAndReturnError(&error)
        if !fileExists { print(error) }
        
        
        if fileExists == true {
            
            var optData:NSData? = nil
            do {
                optData = try NSData(contentsOfURL: fileURL, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            }
            catch {
                print("Handle \(error) here")
            }
            
            if let data = optData {
                let image = UIImage(data:data, scale:1.0)
                self.comicImageView.image = image

            }
            return
        }
        
        // Download a file
        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            // generate a unique name for this file in case we've seen it before
            return directoryURL.URLByAppendingPathComponent(localName)
        }
        
        if let client = Dropbox.authorizedClient {
            client.files.download(path: localPath, destination: destination).response { response, error in
                if let (_, url) = response, data = NSData(contentsOfURL: url) {
                    let image = UIImage(data:data, scale:1.0)
                    self.comicImageView.image = image
                } else {
                    print(error!)
                }
            }
        }
    }
}
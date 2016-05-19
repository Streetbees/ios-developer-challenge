//
//  ComicDetailViewModel.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2015 MarvelStreetbees. All rights reserved.
//

import Foundation
import RxSwift
import PKHUD
import SwiftyDropbox



// conversion
extension UIImage {
    
    class func getNSData(image: UIImage) throws -> NSData {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            throw NetworkError.Custom(message: "UIImageJPEGRepresentation error")
        }
        
        return data
    }
}




// ============================================================================
class ComicDetailViewModel {
    
    var comic: MarvelComic? {
        didSet {
            if let comic = comic, title = comic.title {
                self.title.onNext(title)
            }
            if let comic = comic, description = comic.description {
                self.description.onNext(description)
            }
            
            requestComicImage()
        }
    }
    
    let thinking = PublishSubject<HUDState>()
    
    let needsAuthorization = PublishSubject<Bool>()
    
    let title = ReplaySubject<String>.create(bufferSize: 1)
    let description = ReplaySubject<String>.create(bufferSize: 1)
    let thumbnailImage = ReplaySubject<UIImage>.create(bufferSize: 1)
    
    
    let disposeBag = DisposeBag()
    private var client : SwiftyDropbox.DropboxClient?
    
    

    func uploadImage() {
        guard let client = Dropbox.authorizedClient else {
            self.needsAuthorization.onNext(true)
            self.thinking.onNext(.ErrorWithMessage("Please login then try again :)"))
            return
        }
        
        guard let comic = comic, id = comic.id else {
            self.thinking.onNext(.ErrorWithMessage("Comic data not found!"))
            return
        }

        let imageFileName = "\(id).jpg"
        let imageDropboxPath = Constants.Settings.kMarvelDropboxFolder + "/" + imageFileName
        
        
        Observable.just(("\(id)", Constants.Settings.kMarvelDropboxFolder))
            .doOnNext { [weak self] _ in
                self?.thinking.onNext(.Started)
            }
            
            // check if image already exists
            .flatMapLatest { (name, path) in
                client.rx_fileExists(name, atPath: path)
            }
            .filter({ $0 == false })
            
            
            .doOnError({ [weak self] error in
                print(error)
                if let _error = error as? NetworkError {
                    if case NetworkError.DropBoxNotAuthorized = _error {
                        Dropbox.unlinkClient()
                        self?.needsAuthorization.onNext(true)
                    }
                }
            })
            
            .withLatestFrom(self.thumbnailImage)
            .map(UIImage.getNSData)
            .flatMapLatest { imageData in
                client.rx_upload(path: imageDropboxPath, body: imageData)
            }
            .subscribe { event in
                
                switch event {
                case .Next(_):
                    break
                case .Error(let error):
                    if let error = error as? CustomStringConvertible {
                        self.thinking.onNext(.ErrorWithMessage(error.description))
                    } else {
                        self.thinking.onNext(.ErrorWithMessage("unknown error"))
                    }
                case .Completed:
                    self.thinking.onNext(.Success)
                }
            }
            .addDisposableTo(disposeBag)

    }
    
    func requestComicImage() {
        
        guard let comic = comic, thumbnail = comic.thumbnail, imageURL = thumbnail.imageURLString(.PortraitFantastic) else {
            self.thinking.onNext(.ErrorWithMessage("Comic data not found!"))
            return
        }
        
        NetworkManager
            .requestImage(imageURL)
            .subscribeNext { [weak self] image in
                self?.thumbnailImage.onNext(image)
            }
            .addDisposableTo(disposeBag)
    }
    
}
//
//  ComicCell.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 Parhelion Software. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire
import RxSwift
import RxCocoa


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
        reuseSignal.onNext(true)
    }
    
    func updateCellWithComic(comic: MarvelComic) {
       self.comicNameLabel.text = comic.title
        guard let thumbnail = comic.thumbnail, let imageURL = thumbnail.imageURLString(.Medium) else {
            return
        }
        
        NetworkManager
            .requestImage(imageURL)
            .takeUntil(self.reuseSignal.asObservable().filter({ $0 == true }))
            .subscribeNext { [weak self] image in
            self?.comicImageView.image = image
        }
        .addDisposableTo(disposeBag)
    }
}
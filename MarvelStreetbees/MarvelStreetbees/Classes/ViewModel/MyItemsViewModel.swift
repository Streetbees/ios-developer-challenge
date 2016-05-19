//
//  MyItemsViewModel.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2015 MarvelStreetbees. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyDropbox

class MyItemsViewModel {
    

    
    let thinking = PublishSubject<HUDState>()
    let comics = PublishSubject<[MarvelComic]>()
    let needsAuthorization = PublishSubject<Bool>()

    private let disposeBag = DisposeBag()
    private var client : DropboxClient?

    
    
    func getComics() {
        
        guard let client = Dropbox.authorizedClient else {
            self.needsAuthorization.onNext(true)
            self.thinking.onNext(.ErrorWithMessage("Please login then try again :)"))
            return
        }
        

        
        client
            .rx_list(path: Constants.Settings.kMarvelDropboxFolder)
            .map({ $0.map({ MarvelComic(fromFile: $0) }) })
            .subscribe { [weak self] event in
                
                switch event {
                case .Next(let comics):
                    self?.comics.onNext(comics)
                case .Error(let error):
                    if let error = error as? CustomStringConvertible {
                        self?.thinking.onNext(.ErrorWithMessage(error.description))
                    } else {
                        self?.thinking.onNext(.ErrorWithMessage("unknown error"))
                    }
                case .Completed:
                    break
                }
            }
            .addDisposableTo(disposeBag)
    }
    
}
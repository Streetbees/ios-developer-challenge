//
//  ComicsDetailDataBinding.swift
//  MarvelStreetbees
//
//  Created by Pralea Danut on 3/29/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD
import SwiftyDropbox

extension ComicDetailViewController {
    func setupBindings() {
        
        viewModel
            .title
            .observeOn(MainScheduler.instance)
            .bindTo(self.titleLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .description
            .observeOn(MainScheduler.instance)
            .bindTo(self.descriptionString.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel
            .thumbnailImage.asObservable()
            .observeOn(MainScheduler.instance)
            .map({ $0 as? UIImage }) // If I do not use this, I loose the ability to integrate the animation easily
            .bindTo(self.comicImageView.rx_imageAnimated(kCATransitionFade))
            .addDisposableTo(disposeBag)
        
        // HUD
        viewModel.thinking
            .observeOn(MainScheduler.instance)
            .subscribeNext { hud_state in
                switch hud_state {
                case .Started:
                    HUD.show(.Progress)
                case .Success:
                    HUD.flash(.Success, delay: 0.5)
                case .SuccessWithMessage(let message):
                    HUD.flash(.LabeledSuccess(title: message, subtitle: nil), delay: 0.5);
                case .ErrorWithMessage(let message):
                    HUD.flash(.LabeledError(title: "Error".localized, subtitle: message), delay: 3.0)
                }
            }
            .addDisposableTo(disposeBag)
        
        // save to dropbox
        saveToDropboxButton
            .rx_tap
            .subscribeNext({ [weak self] _ in
                guard let _self = self else { return }
                
                if let _ = Dropbox.authorizedClient {
                    _self.viewModel.uploadImage()
                } else {
                    print("client is not authorized. Need to authorize")
                    Dropbox.authorizeFromController(_self)
                }
            })
            .addDisposableTo(disposeBag)
        
        // in case upload needs dropbox authorization
        viewModel
            .needsAuthorization
            .throttle(3, scheduler: MainScheduler.instance)
            .filter({ $0 == true })
            .subscribeNext { [weak self] _ in
                
                if let _ = Dropbox.authorizedClient {
                    print("client is already authorized")
                } else {
                    guard let _self = self else { return }
                    Dropbox.authorizeFromController(_self)
                }
            }
            .addDisposableTo(disposeBag)
    }
}

//
//  MyItemslDataBinding.swift
//  MarvelStreetbees
//
//  Created by Pralea Danut on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD
import SwiftyDropbox

extension MyItemsViewController {
    func setupBindings() {
        
        // comics
        viewModel.comics
            .observeOn(MainScheduler.instance).subscribeNext { [weak self] comics in
                self?.contentArray = comics
            }
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

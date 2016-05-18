//
//  LoginDataBinding.swift
//  SportXast
//
//  Created by Pralea Danut on 3/29/16.
//  Copyright © 2016 SportXast. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD

extension ComicsListViewController {
    func setupBindings() {
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
        
        
        viewModel.comicsSubject
            .observeOn(MainScheduler.instance)
            .subscribeNext { value in
                
                if let comicsArray = self.contentArray where comicsArray.count > 0 {
                    self.contentArray?.appendContentsOf(value)
                } else {
                    self.contentArray = value
                }
                self.tableView.stopPullToRefresh()
                self.tableView.endInfiniteScrolling()
            }
            .addDisposableTo(disposeBag)
    }
}

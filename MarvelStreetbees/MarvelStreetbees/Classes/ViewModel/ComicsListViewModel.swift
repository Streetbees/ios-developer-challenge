//
//  EventsViewModel.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 018/05/16.
//  Copyright © 2015 MarvelStreetbees. All rights reserved.
//

import Foundation
import RxSwift
import PKHUD

class ComicsListViewModel {
    
    // ============================================================================
    // observable properties
    let thinking = PublishSubject<HUDState>()
    
    let comicsSubject = PublishSubject<[MarvelComic]>()
    
    // ============================================================================
    let disposeBag = DisposeBag()
    
    
//    var selectedIndex
    
    // ============================================================================
    func updateViewModel(rootResponse: ComicsListRootResponse) {
        if let comics = rootResponse.data?.list {
            self.comicsSubject.onNext(comics)
        }
    }
    

    // ============================================================================
    func makeTheCall(pageSize pageSize: Int, page: Int, showLoading: Bool) {
        
        Observable
            .just(true)
            .doOn { [weak self] _ in
                if showLoading == true {
                    self?.thinking.onNext(.Started)
                }
            }
            .flatMapLatest({ _ in
                return NetworkManager.requestJSON(Router.GetComicsList(pageIndex: page, pageSize: pageSize))
            })
            .map(ComicsListRootResponse.parseJSON)
            .subscribe { [weak self] event in
                switch event {
                case .Next(let value):
                    self?.updateViewModel(value)
                case .Error(let error):
                    print("\(error)")
                case .Completed:
                    print("completed")
                    if showLoading == true {
                        self?.thinking.onNext(.Success)
                    }
                }
            }
            .addDisposableTo(disposeBag)
        
    }
}
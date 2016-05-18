//
//  EventsViewModel.swift
//  Gocus
//
//  Created by Andrei on 08/12/15.
//  Copyright © 2015 ALT TAB Mobile. All rights reserved.
//

import Foundation
import RxSwift
import PKHUD

class ComicDetailViewModel {
    
    var comic: MarvelComic?
    // ============================================================================
    // observable properties
    let thinking = PublishSubject<HUDState>()
    
    let comicsSubject = PublishSubject<[MarvelComic]>()
    
    // ============================================================================
    let disposeBag = DisposeBag()
    
    
}
//
//  ComicListVM.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 17/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

struct ComicVM {
    
    fileprivate let comic : Comic
    
    var imageURL : String {
        return comic.imagePath + "." + comic.imageExtension
    }
    
    var comicTitle : String {
        return comic.title
    }
    
    init(with comic: Comic) {
        self.comic = comic
    }
    
}

class ComicListVM {
    
    var completion : ((_ success: Bool, _ error: String?)->())?
    
    var childViewModels : [ComicVM] = []
    
    let comicManager = ComicManager()
    
    var numberOfComics : Int {
        return childViewModels.count
    }
    
    func viewModel(at index: IndexPath) -> ComicVM {
        
        if index.row == childViewModels.count - 20 {
                comicManager.getComics()
        }
        
        return childViewModels[index.row]
    }
    
    init() {
        
        comicManager.delegate = self
        
        comicManager.getComics()
    }

}

extension ComicListVM: ComicManagerDelegate {
    
    func loaded(comics c: [Comic]) {
        
        c.forEach {
            childViewModels.append(ComicVM(with: $0))
        }
        
        completion?(true, nil)
    }
    
    func failed(toLoadComicsWith error: String) {
        completion?(false, "errror")
    }
    
}



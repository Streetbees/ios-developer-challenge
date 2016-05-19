//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import RxSwift

public class ComicsStore : NSObject, UICollectionViewDataSource {
    
    private let client = MarvelClient()
    public var comics: Variable<[Comic]> = Variable([])
    public var total: Variable<Int> = Variable(0)
    private var comicsIds: [Int:String] = [:]
    private var lastOffset: Int = 0
    let pageCount = 30
    public var isRetrievingComics = Variable(false)
    public var drive: DriveBase?

    override public init() {
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.value.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellComic", forIndexPath: indexPath) as! ComicCell
        
        cell.drive = self.drive
        cell.comic = self.comics.value[indexPath.row]
        
        return cell
    }

    func getMoreComics() {
        if isRetrievingComics.value {
            return
        }

        isRetrievingComics.value = true
        client.getComics(lastOffset, limit: pageCount, completeHandler: {
            [weak self] (result) in
            assert(NSThread.isMainThread())

            guard let selfWeak = self else {
                return
            }

            switch result {
            case .Success(let data):
                if let results = data.data?.results {
                    //add new comics to comics array
                    var newComics: [Comic] = []
                    
                    for comic:Comic in results {
                        //if is a new comic (id is not in dictionary of IDs)
                        //needs to do this check, because the API could has new items, and the offset will return old values, so
                        // we need to be sure they are not already in the store
                        if let comicId = comic.comicId {
                            if selfWeak.comicsIds[comicId] == nil {
                                selfWeak.comicsIds[comicId] = "1"
                                
                                newComics.append(comic)
                            }
                        }
                    }
                    if newComics.count>0 {
                        //add new comics in one call so Rx can signal on this change
                        selfWeak.comics.value.appendContentsOf(newComics)
                    }
                        
                    if let count = data.data?.total {
                        selfWeak.total.value = count
                    }
                    
                    //set new offset to be used in next call
                    selfWeak.lastOffset += selfWeak.pageCount
                }
                
            case .Error(_):
                //TODO show error somewhere
                break
            }

            //ready for new calls
            selfWeak.isRetrievingComics.value = false
        })
    }

    func reset() {
        //reset all values/content
        self.lastOffset = 0
        self.comicsIds = [:]
        self.comics.value = []
    }
}

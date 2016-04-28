//
//  Marveler.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 25/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import Alamofire
import Backgroundable
import BLLogger
import CryptoSwift


//MARK: - Marveler Delegate
/*
 This is how other objects get responses from the Marveler
 */
public protocol MarvelerDelegate: AnyObject
{
    associatedtype M
    func willStartLoadingMarvelComics() //We call this method when the Marveler is about to load data from the network
    func willFinishLoadingMarvelComics(errorMessage: String?) //We call this method when we have finished loading data from the network, but haven't finished processing each individual comic
    func didFinishLoadingMarvelComics<M>(comic: M) //We call this method for each individual comic that has finished loading, so we can update the UI in a more NSFetchedResultsController fashion
}


//MARK: - Marveler, the Controller
/*
 This is the main interface for everything Marvel
 In good MVC fashion, the Marveler is the controller that handles requests to the Marvel remote API
 */
public final class Marveler<C: MarvelComic, D: MarvelerDelegate>
{
    //MARK: Setup
    /*
     Instantiating a new Marveler with a delegate
     */
    public private(set) weak var delegate: D?
    
    public init(delegate: D)
    {
        self.delegate = delegate
        Manager.sharedInstance.startRequestsImmediately = false //Nuke disables this anyway, so...
    }
    
    //MARK: Getting comics
    /*
     This is how we get comics from Marvel's API
     This method receives a starting point, meant to be passed along to Marvel's API as the offset parameter
     This is so we only load the items that are currently visible to the user
     For now, we're loading data in chunks of 100 (which is the limit imposed by Marvel) and holding all the results in an array
     */
    //TODO: Optimise this so we only load the objects that have not been fetched yet
    private let limit = 100
    
    private var loading = false
    
    public final func getComics(startingAt position: Int)
    {
        guard !self.loading else { return }
        self.loading = true
        
        self.delegate?.willStartLoadingMarvelComics()
        
        //Helper function that finishes everything
        func end(errorMessage: String?) {
            onTheMainThread { [weak self] _ in
                self?.delegate?.willFinishLoadingMarvelComics(errorMessage)
            }
            self.loading = false
            guard errorMessage == nil else {
                //We reset our data model if we have an error
                self.totalComics = 0
                self.comics = nil
                return
            }
            self.traverseComics(withPosition: position) { [weak self] (element) -> Bool in
                onTheMainThread { [weak self] _ in
                    self?.delegate?.didFinishLoadingMarvelComics(element)
                }
                return false
            }
        }
        
        //Helper function that loads everything
        func load() {
            let timestamp = Int(NSDate().timeIntervalSince1970)
            let publicKey = "dacd1ca87689d8a3cdf0458a441917be"
            let privateKey = "4b3ec5305b3b8efb3ee876dc0cd6bd81a8bf9a24"
            let hash = "\(timestamp)\(privateKey)\(publicKey)".md5()
            Manager.sharedInstance.request(.GET, "http://gateway.marvel.com:80/v1/public/comics", parameters: ["noVariants": true, "orderBy": "-onsaleDate", "limit": self.limit, "offset": position, "apikey": publicKey, "ts": timestamp, "hash": hash]).responseJSON { [unowned self] (response: Response<AnyObject, NSError>) in
                
                inTheBackground { [unowned self] _ in
                    
                    dLog("Marveler response: \(response.result.value)")
                    
                    let errorMessage = "Oops... Something went wrong.\nWould you mind trying again?"
                    
                    guard let JSON = response.result.value else { end(errorMessage); return }
                    guard let code = JSON["code"] as? Int else { end(errorMessage); return }
                    guard let data = JSON["data"] as? [String: AnyObject] else { end(errorMessage); return }
                    guard let results = data["results"] as? [[String: AnyObject]] else { end(errorMessage); return }
                    guard let total = data["total"] as? Int else { end(errorMessage); return }
                    guard let offset = data["offset"] as? Int else { end(errorMessage); return }
                    guard let count = data["count"] as? Int else { end(errorMessage); return }
                    guard let urlResponse = response.response else { end(errorMessage); return }
                    guard code == 200 else { end(errorMessage); return }
                    
                    self.totalComics = total
                    
                    if self.comics == nil {
                        self.comics = []
                        for _ in 0..<self.totalComics {
                            self.comics!.append(C())
                        }
                    }
                    
                    let newComics = C.collection(response: urlResponse, representation: results)
                    var newIndex = 0
                    
                    for i in offset..<offset + count {
                        self.comics![i] = newComics[newIndex]
                        newIndex += 1
                    }
                    
                    end(nil)
                    
                }
            }.resume()
        }
        
        //Now, we check if we haven't loaded anything yet
        guard totalComics > 0 else {
            load()
            return
        }
        
        //If we have already loaded something, let's check if each object has also been loaded
        inTheBackground { [weak self] _ in
            guard let weakSelf = self else { return }
            if weakSelf.shouldLoad(withPosition: position) {
                load()
                return
            }
            end(nil)
        }
    }
    
    /*
     This indicates how many comics we have
     We shall populate this variable once we make our first call to the API
     */
    public private(set) var totalComics = 0
    
    /*
     Here's where we store the last result we got from the API
     Although it's not great to hold 30k+ objects in an array at once, it's not too bad either
     We can probably optimise this later on
     */
    public private(set) var comics: [C]?
    
    public final func updateComics(comics: [C])
    {
        guard let current = self.comics else { return }
        self.updateComicsRecursive(comics, current)
    }
    
    private func updateComicsRecursive(c: [C], _ current: [C]) {
        guard !c.isEmpty else { return }
        
        var comics = c
        let comic = comics.removeLast()
        
        for (index, element) in current.enumerate() {
            if comic == element {
                self.comics?[index] = comic
                onTheMainThread { [weak self] _ in
                    self?.delegate?.didFinishLoadingMarvelComics(comic)
                }
                break
            }
        }
        
        self.updateComicsRecursive(comics, current)
    }
    
    /*
     Helper method to traverse the elements in our result array according to the range we want to investigate
     We return true on the traverse block to shortcircuit the loop
     */
    private func traverseComics(withPosition position: Int = 0, _ block: (element: C) -> Bool) {
        guard let comics = self.comics else { return }
        let last = limit + position - 1
        for (index, comic) in comics.enumerate() {
            //Since we're just investigating the comics that are within the limit's range, we shortcircuit when we're out of bounds
            if index >= last { break }
            if index >= position {
                if block(element: comic) == true {
                    break
                }
            }
        }
    }
    
    /*
     Helper method to determine if we should load more stuff from the API
     */
    private func shouldLoad(withPosition position: Int) -> Bool {
        var result = false
        self.traverseComics(withPosition: position) { (element) in
            guard !element.hasBeenSummoned else { return false }
            result = true
            return true
        }
        return result
    }
}

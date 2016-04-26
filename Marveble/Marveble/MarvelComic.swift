//
//  MarvelComic.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import Alamofire


//MARK: - Marvel Comic
public protocol MarvelComic: ResponseObjectSerializable, ResponseCollectionSerializable, Equatable
{
    var comicId: Int? { get } //The comic's ID if it has been loaded
    var hasBeenSummoned: Bool { get } //This computed property evaluates if the Marvel Comic has already been downloaded, so we don't re-download stuff
    var title: String { get } //The title of the comic
    var description: String? { get } //The comic's description, if available
    var thumbURL: NSURL? { get } //The comic's thumbnail URL
    
    init() //Initialises a new empty Marvel Comic, so we can populate it later
    init(comicId: Int, title: String, description: String?, thumbPath: String, thumbExtension: String)
}

public extension MarvelComic
{
    var hasBeenSummoned: Bool {
        return self.comicId != nil
    }
    
    static func makeThumbURL(withPath path: String, andExtension ext: String) -> NSURL?
    {
        return NSURL(string: path)?.URLByAppendingPathComponent("portrait_fantastic").URLByAppendingPathExtension(ext)
    }
    
    //MARK: Serialising
    /*
     We're expecting one element of the JSON response's 'data' array here
     */
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        guard let representation = representation as? [String: AnyObject] else { return nil }
        guard let title = representation["title"] as? String,
            let comicId = representation["id"] as? Int,
            let thumbnail = representation["thumbnail"] as? [String: String]
            else { return nil }
        guard let thumbPath = thumbnail["path"],
            let thumbExtension = thumbnail["extension"]
            else { return nil }
        
        self.init(comicId: comicId, title: title, description: representation["description"] as? String, thumbPath: thumbPath, thumbExtension: thumbExtension)
    }
    
    /*
     We're expecting the JSON response's 'results' array here
     */
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
        var result = [Self]()
        
        guard let representation = representation as? [[String: AnyObject]] else { return result }
        
        for comicRepresentation in representation {
            if let comic = Self(response: response, representation: comicRepresentation) {
                result.append(comic)
            }
        }
        
        return result
    }
}

func ==<M: MarvelComic>(lhs: M, rhs: M) -> Bool {
    guard let leftId = lhs.comicId, let rightId = rhs.comicId else { return false }
    return leftId == rightId
}

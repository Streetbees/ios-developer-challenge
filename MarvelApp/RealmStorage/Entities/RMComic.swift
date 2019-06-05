//
//  RMComic.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//
import Foundation
import RealmSwift

final class RMComic: Object {
    
    @objc dynamic var _primaryKey: String = ""

    @objc dynamic var id: Int = 0
    @objc dynamic var digitalId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var issueNumber: Int = 0
    @objc dynamic var variantDescription: String = ""
    @objc dynamic var comicDescription: String? = nil
    @objc dynamic var modified: Date = Date()
    @objc dynamic var format: String = ""
    @objc dynamic var pageCount: Int = 0
    @objc dynamic var resourceURI: String = ""
    @objc dynamic var thumbnail: RMComicImage? = RMComicImage()
    var images: List<RMComicImage>? = List<RMComicImage>()
    
    override class func primaryKey() -> String? {
        return "_primaryKey"
    }
}

extension RMComic: DomainConvertibleType {
    func asDomain() -> Comic {
        return Comic(id: id,
                     digitalId: digitalId,
                     title: title,
                     issueNumber: issueNumber,
                     variantDescription: variantDescription,
                     description: comicDescription,
                     modified: modified,
                     format: format,
                     pageCount: pageCount,
                     resourceURI: resourceURI,
                     thumbnail: thumbnail!.asDomain(),
                     images: (images?.map { $0.asDomain() }) ?? [])
    }
}

extension Comic: RealmRepresentable {
    
    var _primaryKey: String {
        return String(id)
    }
    
    func asRealm() -> RMComic {
        return RMComic.build { object in
            object._primaryKey = _primaryKey
            object.id = id
            object.digitalId = digitalId
            object.title = title
            object.issueNumber = issueNumber
            object.variantDescription = variantDescription
            object.comicDescription = description
            object.modified = modified
            object.format = format
            object.pageCount = pageCount
            object.resourceURI = resourceURI
            object.thumbnail = thumbnail.asRealm()
            object.images = List(images.map { $0.asRealm() })
        }
    }
}

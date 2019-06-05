//
//  RMComicImage.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import RealmSwift

final class RMComicImage: Object {
    
    @objc dynamic var path: String = ""
    @objc dynamic var imageExtension: String = ""
}

extension RMComicImage: DomainConvertibleType {
    func asDomain() -> ComicImage {
        return ComicImage(path: path, imageExtension: imageExtension)
    }
}

extension ComicImage: RealmRepresentable {
    
    //Not used
    var _primaryKey: String {
        return ""
    }
    
    func asRealm() -> RMComicImage {
        return RMComicImage.build { object in
            object.path = path
            object.imageExtension = imageExtension
        }
    }
}

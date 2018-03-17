//
//  Comic.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 17/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

struct Comic {
    
    var imagePath : String
    var imageExtension : String
    var title : String
    
    init(with json: JSON) {

        imageExtension = (json["thumbnail"] as? JSON)?["extension"] as? String ?? "NA"
        imagePath = (json["thumbnail"] as? JSON)?["path"] as? String ?? "NA"
        title = json["title"] as? String ?? "nope"
    }
    
}

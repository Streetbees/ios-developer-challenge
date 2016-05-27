//
//  Comic.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import Foundation

struct Comic {
    
    let id: Int?
    let isbn: String?
    let title: String?
    let issueNumber: Int?
    let description: String?
    let imagePath: String?
    let imageExtension: String?
    let series:	String?
    let pageCount: Int?
    var dropboxFileName: String {
        return "/Cover-\(id!).\(imageExtension ?? "jpg")"
    }
    
    init (id: Int?, isbn: String?, title: String?, issueNumber: Int?, description: String?, imagePath: String?, imageExtension: String?, series: String?, pageCount: Int?) {
        
        self.id = id
        self.isbn = isbn
        self.title = title
        self.issueNumber = issueNumber
        self.description = description
        self.imagePath = imagePath
        self.imageExtension = imageExtension
        self.series = series
        self.pageCount = pageCount
    }
    
}
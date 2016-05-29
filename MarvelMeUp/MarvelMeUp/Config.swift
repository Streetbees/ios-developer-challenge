//
//  Config.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/23/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    static let marvelPublicKey = "678b073b6e9a2dcefb279915f8c2a745"
    static let marvelPrivateKey = "1c08cb453c7f13585d8c31f1e1679cf397500ad3"
    static let marvelBaseUrl = "https://gateway.marvel.com:443/v1/public"
    static let marvelImageName = "portrait_uncanny"
    static let marvelThumbnailName = "standard_medium"

    static let imageQuality: CGFloat = 0.85
    static let thumbQuality: CGFloat = 0.7
    static let imageWidth: CGFloat = 450
    static let thumbWidth: CGFloat = 300

}
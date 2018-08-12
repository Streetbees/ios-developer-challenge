//
//  UIDeviceHelper.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {

    enum ScreenSize: String {
        case Large = "iPhone X, iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case Regular = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case Small = "iPhone 4 or iPhone 4S, iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case unknown
    }

    
    var screenSize: ScreenSize {
        switch UIScreen.main.nativeBounds.height {
        case 960, 1136:
            return .Small
        case 1334:
            return .Regular
        case 1920, 2208, 2436:
            return .Large
        default:
            return .unknown
        }
    }
    
}

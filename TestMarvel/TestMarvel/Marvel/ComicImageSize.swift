//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import UIKit

public enum ComicImageSize : String {
    //from http://developer.marvel.com/documentation/images
    
    case portrait_small = "portrait_small" //50x75px
    case portrait_medium = "portrait_medium" //100x150px
    case portrait_xlarge = "portrait_xlarge" //150x225px
    case portrait_fantastic = "portrait_fantastic" //168x252px
    case portrait_uncanny = "portrait_uncanny" //300x450px
    case portrait_incredible = "portrait_incredible" //216x324px

    static public func forScale(scale: CGFloat) -> ComicImageSize {
        switch scale {
        case 1:
            return ComicImageSize.portrait_medium
        case 2:
            return ComicImageSize.portrait_incredible
        case 3...10:
            return ComicImageSize.portrait_uncanny

        default:
            return ComicImageSize.portrait_incredible
        }
    }
}

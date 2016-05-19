//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import Gloss

public class ComicThumbnail : Decodable {
    let path: String?
    let ext: String?

    required public init?(json: JSON) {
        self.path = "path" <~~ json
        self.ext = "extension" <~~ json
    }

    public func absoluteString(size: ComicImageSize) -> String {
        guard let path = self.path, ext = self.ext else {
            return ""
        }
        
        return path+"/"+size.rawValue+"."+ext
    }
}

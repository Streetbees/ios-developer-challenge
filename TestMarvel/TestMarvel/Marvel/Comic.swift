//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import Gloss
import RxSwift

public class Comic : Decodable {
    let comicId: Int?
    let title: String?
    let thumbnail: ComicThumbnail?
    
    var uploadProgress = Variable(0.0)
    var isUploading: Bool = false

    required public init?(json: JSON) {
        self.comicId = "id" <~~ json
        self.title = "title" <~~ json
        self.thumbnail = "thumbnail" <~~ json
    }
    
    public func thumbnailURLForScale(scale: CGFloat) -> String {
        guard let thumbnail = self.thumbnail else {
            return ""
        }

        return thumbnail.absoluteString(ComicImageSize.forScale(scale))
    }
}

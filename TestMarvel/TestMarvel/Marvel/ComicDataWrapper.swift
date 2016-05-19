//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import Gloss

public class ComicDataWrapper : Decodable {
    let code: Int?
    let status: String?
    let data: ComicDataContainer?

    required public init?(json: JSON) {
        self.code = "code" <~~ json
        self.status = "status" <~~ json
        self.data = "data" <~~ json
    }
}

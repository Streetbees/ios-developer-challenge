//
// Copyright (c) 2016 agit. All rights reserved.
//

import Foundation
import Gloss

public class ComicDataContainer : Decodable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Comic]?

    required public init?(json: JSON) {
        self.offset = "offset" <~~ json
        self.limit = "limit" <~~ json
        self.total = "total" <~~ json
        self.count = "count" <~~ json
        self.results = "results" <~~ json
    }
}

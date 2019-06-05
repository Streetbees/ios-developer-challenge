//
//  DataModels.swift
//  Marvellous
//
//  Created by Gustaf Kugelberg on 2018-08-21.
//  Copyright © 2018 Unfair Advantage. All rights reserved.
//

import Foundation
import RealmSwift

struct ComicDataWrapper: Decodable {
    let code: Int
    let status: String
    let etag: String

    let data: ComicDataContainer
}

struct ComicDataContainer: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int

    let results: [Comic]

    var downloadedRange: CountableRange<Int> {
        return CountableRange(offset..<offset + count)
    }
}

class Comic: Object, Decodable {
    struct Image: Decodable {
        let path: String
        let `extension`: String

        var urlString: String? { return URL(string: path)?.appendingPathExtension(self.extension).absoluteString }
    }

    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var format: String = ""
    @objc dynamic var resourceURI: String = ""
    @objc dynamic var thumbnailPath: String? = nil
    @objc dynamic var thumbnail: Data? = nil

    @objc dynamic var offset: Int = 0

    override static func primaryKey() -> String? {
        return "offset"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case format
        case resourceURI
        case thumbnail
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.format = try container.decode(String.self, forKey: .format)
        self.resourceURI = try container.decode(String.self, forKey: .resourceURI)
        self.thumbnailPath = try container.decode(Image.self, forKey: .thumbnail).urlString
    }
}
